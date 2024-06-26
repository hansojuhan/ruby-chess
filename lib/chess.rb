require 'pry-byebug'
require_relative 'chess_pieces'
require_relative 'utilities'

class Chess
  include ChessUtilities

  attr_accessor :history, :last_notification_message, :game_over, :board, :current_move, :game_metadata

  # Chess board rows
  ROWS = 'abcdefgh'

  # Test mode (use array coordinates, not notation)
  TESTMODE = false

  def initialize
    # Initialise the board as an 8x8 array
    @board = Array.new(8) { Array.new(8) }

    # History containing all game moves done
    @history = []
    
    # Current move (either :black or :white)
    @current_move = nil

    # Variable to save the most recent error/notification message
    @last_notification_message = ""

    # Play until this is true
    @game_over = false

    # Game metadata (according to the PGN format)
    @game_metadata = {
      event: "?",
      site: "?",
      date: "????.??.??",
      round: "?",
      white: "?",
      black: "?",
      result: "*"
    }
  end

  def print_intro_screen
    print `clear`
    print"\nWelcome to Chess!\n---\nCreated by hje\nMay 2024\n\n(N) New game\t\t(L) Load game\t\t(Q) Quit\n\nChoose: "
  end
  
  def main_menu
    loop do
      # Ask user to load game, if they wish
      print_intro_screen

      # Get choice
      choice = gets.chomp
      choice = choice.downcase

      # Make actions based on choice
      if ["q","quit","quit game"].include?(choice)
        
        print `clear`
        puts "Ciao!"
        exit(true)
        
      elsif ["l","load","load game"].include?(choice)

        load_game
        return

      elsif ["n","new","new game"].include?(choice)

        initialize_game
        return

      end
    end
  end

  def start
    #Start with main menu
    main_menu

    # Game loop
    while !game_over do
      
      render_board
      make_move

      if game_over 
        render_board
        puts "Return to main menu"
        gets
        main_menu
      end
    end

  end

  # Getter for current move
  def current_move
    # If history is empty (new game) or last turn was finished, white
    # Otherwise black
    (history.empty? || (history[-1][0] && history[-1][1])) ? :white : :black 
  end

  # Render the current state of the @board with letters and numbers
  def render_board

    print `clear`
    print "\n"

    # Render current move
    print "Current move: #{current_move}\n"

    # Show the last game message
    unless last_notification_message.empty?
      print "NB: #{last_notification_message}\n" 
      self.last_notification_message = ""
    else
      print "\n"
    end

    print "\n"

    board.each_with_index do |row, row_number|
      # Print row numbers
      test_row_number = TESTMODE ? "(#{row_number}) " : ""
      print "#{8 - row_number}  #{test_row_number}"
      # print " #{8 - row_number} " TODO

      # If square is nil, print out dot, if object, print out object's symbol
      row.each do |square|
        print square.nil? ? " · " : " #{square.symbol} "
      end
      
      print "\n"
    end

    # Letters underneath
    if TESTMODE
      print "        0  1  2  3  4  5  6  7\n" 
      print "        a  b  c  d  e  f  g  h\n\n"
    else
      print "    a  b  c  d  e  f  g  h\n\n"
    end
        
    # Show game history
    render_history
  end

  def make_move
    if TESTMODE
      # Get coordinates from array positions:
      origin = parse_input_basic_array "From:"
      destination = parse_input_basic_array "To:"
    else
      # Get two coordinates from algebraic notation:
      origin = parse_input "From:"
      destination = parse_input "To:"
    end  
    
    # Find piece
    piece = get_piece_basic(origin)
    opponents_piece = get_piece_basic(destination)

    # Check if piece was found
    unless piece
      self.last_notification_message = "Choose a #{current_move} piece on the board!" 
      return false
    end

    # Check if found piece is the same color as current move
    unless piece.color == current_move
      self.last_notification_message = "It's #{current_move} turn! Choose the right piece."
      return false
    end

    # Move it if move is valid
    if !piece.nil? && piece.valid_move?(board, origin, destination)

      # # Check if after move own king is checked, if yes, not valid move 
      if own_king_checked?(board, piece, origin, destination, current_move)
        self.last_notification_message = "Can't move there (check)!"
        return false
      end

      # If destination includes an opponent's piece, take it, otherwise move
      unless opponents_piece.nil?
        take_piece(piece, opponents_piece, origin, destination)
      else
        move_piece(board, piece, origin, destination)
      end

      # Check if check occured
      opponent_king_color = current_move == :white ? :black : :white

      if king_checked?(board, opponent_king_color)
        if king_checkmated?(board, opponent_king_color)
          # Game is over
          self.game_over = true          

          mate = true
          self.last_notification_message = "Checkmate!"
        else
          check = true
          self.last_notification_message = "#{piece.color.capitalize} #{piece.class.name.downcase} checks #{opponent_king_color} king!" if king_checked?(board, opponent_king_color)
        end
      end

      # Finish move, record history
      update_history(piece, opponents_piece, origin, destination, check, mate)
      return true
    else
      self.last_notification_message = "This is not a valid move."
      return false
    end
  end
  
  def set_piece(piece, coordinates)
    # Parse coordinates both as letters or numbers
    board_column = ROWS.index(coordinates[0])
    board_row = 8 - coordinates[1].to_i

    self.board[board_row][board_column] = piece
  end

  def own_king_checked?(board, piece, origin, destination, color)
    # Deep local copy of the board
    local_board = Marshal.load(Marshal.dump(board))
    # Make hypothetical move
    move_piece(local_board, piece, origin, destination, false)
    # Check for check
    return king_checked?(local_board, color)    
  end

  # Render game turn history per round
  def render_history
    puts "Turns:" unless history.empty?
    history.each_with_index do |round, round_number|
      print "#{round_number + 1}) #{round[0]},\t#{round[1]}\n"
    end
  end

  # Writes up history in chess algebraic notation
  def update_history(piece, opponents_piece = nil, origin, destination, check, mate)
    # Rules:
    # 1. To write a move, give name of piece and destination square. 
    # 2. If piece captured, include x for "captures" before the destination square.
    # 2.1. When a pawn makes a capture, always include the originating file, as in fxe4 and gxf6 above.
   
    # Symbols:
    # x: captures
    # 0-0: kingside castle
    # 0-0-0: queenside castle
    # +: check
    # #: checkmate

    # Pieces:
    #  :  pawn (no symbol)
    # R:  rook
    # B:  bishop
    # N:  knight
    # Q:  queen
    # K:  king
    
    # Writing the move:
    # Moves are in pairs: turn: white move, black move
    # Example:  1. Nc3, f5
    
    # To write down a move:
    move = ""
    # Get the notation symbol for piece (N, B, etc.)
    move << piece.notation_symbol
    # check if piece was taken, in which case add 'x'
    move << 'x' unless opponents_piece.nil?
    # write destination
    move << coordinates_to_string(destination)
    # add +, # in case of check, mate
    move << '+' if check
    move << '#' if mate

    # empty (first move of the game)
    if history.empty?
      # Write first move into it and add to history array
      history.push [move, nil]

    elsif history[-1][0] && history[-1][1].nil?
      # white move done: ["e4",nil]
      # Take the last element in the history array
      # Add new move to the second place of it
      history[-1][1] = move

    elsif history[-1][0] && history[-1][1]
      # black move done: ["e4","d6"]
      # Create a new 2-element array
      # Write first move into it and add to history array
      history.push [move, nil]
    end
  end

  # Takes in array coordinates [1, 3] and outputs chess notation "d7"
  def coordinates_to_string(coordinates)
    # Input will be [1, 3] (row, column)
    output = ""
    # Output should be "d7"
    output << 'abcdefgh'[coordinates[1]]
    output << (8 - coordinates[0]).to_s
    
    return output
  end

  # Take an opponent's piece and move piece to that place
  def take_piece(piece, opponents_piece, origin, destination)
    # What to do to take
    
    # Move piece to destination
    board[destination[0]][destination[1]] = piece
    # Remove from origin
    board[origin[0]][origin[1]] = nil
    
    # Set opponents piece as taken
    # needed?
    opponents_piece.taken = true

    # Increment piece's move counter
    piece.moves_done += 1

    # Set game message
    self.last_notification_message = "#{piece.color.capitalize} #{piece.class.name.downcase} has taken the #{opponents_piece.color} #{opponents_piece.class.name.downcase}."
  end

  # Move piece on the board
  def move_piece(board, piece, origin, destination, increment_moves = true)
    # Need to move piece into the array position at destination
    board[destination[0]][destination[1]] = piece
    # And remove from origin
    board[origin[0]][origin[1]] = nil
    # Increment piece's own move counter
    piece.moves_done += 1 if increment_moves
  end

  # Get piece from board array
  def get_piece_basic(array)
    board[array[0]][array[1]]
  end

  # Reset all game history, initialise variables and set pieces on board in starting position
  def initialize_game

    # Clear board
    self.board = Array.new(8) { Array.new(8) }

    # Set pieces
    set_piece(Pawn.new(:white),["a", 2])
    set_piece(Pawn.new(:white),["b", 2])
    set_piece(Pawn.new(:white),["c", 2])
    set_piece(Pawn.new(:white),["d", 2])
    set_piece(Pawn.new(:white),["e", 2])
    set_piece(Pawn.new(:white),["f", 2])
    set_piece(Pawn.new(:white),["g", 2])
    set_piece(Pawn.new(:white),["h", 2])

    set_piece(Rook.new(:white),["a",1])
    set_piece(Knight.new(:white),["b",1])
    set_piece(Bishop.new(:white),["c",1])
    set_piece(Queen.new(:white),["d",1])
    set_piece(King.new(:white),["e",1])
    set_piece(Bishop.new(:white),["f",1])
    set_piece(Knight.new(:white),["g",1])
    set_piece(Rook.new(:white),["h",1])

    set_piece(Pawn.new(:black),["a", 7])
    set_piece(Pawn.new(:black),["b", 7])
    set_piece(Pawn.new(:black),["c", 7])
    set_piece(Pawn.new(:black),["d", 7])
    set_piece(Pawn.new(:black),["e", 7])
    set_piece(Pawn.new(:black),["f", 7])
    set_piece(Pawn.new(:black),["g", 7])
    set_piece(Pawn.new(:black),["h", 7])

    set_piece(Rook.new(:black),["a",8])
    set_piece(Knight.new(:black),["b",8])
    set_piece(Bishop.new(:black),["c",8])
    set_piece(Queen.new(:black),["d",8])
    set_piece(King.new(:black),["e",8])
    set_piece(Bishop.new(:black),["f",8])
    set_piece(Knight.new(:black),["g",8])
    set_piece(Rook.new(:black),["h",8])

    # Reset everything
    self.history = []
    self.current_move = nil
    self.last_notification_message = ""
    self.game_over = false
    self.game_metadata = {
      event: "?",
      site: "?",
      date: "????.??.??",
      round: "?",
      white: "?",
      black: "?",
      result: "*"
    }
  end

  def parse_input_basic_array(query_text)
    input_gotten = false
    until input_gotten do
      
      print "#{query_text}\t"
      input = gets.chomp

      if input.length == 2 && input[0].to_i.between?(0,7) && input[1].to_i.between?(0,7)
        result = input.split("")
        result = result.map { |e| e.to_i }
        return result
      else
        self.last_notification_message = "Choose a #{current_move} piece on the board!"
        render_board
      end
    end
  end

  # Returns move array[column, row] if they are coordinates on the chess board
  # For example, [a, 1], [g, 8]
  def parse_input(query_text)
    input_gotten = false
    until input_gotten do
      
      print "#{query_text}\t"
      input = gets.chomp

      # Check if input is a command, such as 'quit', 'save'
      enter_command(input) if input_valid_command?(input)

      if input.length == 2 && ('abcdefgh').include?(input[0]) && input[1].to_i.between?(1,8)
        result = input.split("")

        # Translate to array coordinates
        result.insert(0, result.delete_at(1))
        result[0] = 8 - result[0].to_i
        result[1] = ('abcdefgh').index(result[1])

        return result
      else
        self.last_notification_message = "Choose a #{current_move} piece on the board!"
        render_board
      end
    end
  end

  def input_valid_command?(input)
    ["quit","save"].include? input
  end

  def enter_command(input)
    case input
    when 'quit'
      main_menu
    when 'save'
      save_game
    end
  end

  def king_checked?(board, color)

    pieces = []
    destination = []

    # Get all pieces on board
    board.each_with_index do |row, row_index|
      row.each_with_index do |square, column_index|
        unless square.nil?
          if square.color != color
            pieces.push [square, [row_index, column_index]]
          elsif square.color == color && square.is_a?(King)
            destination = [row_index, column_index]
          end
        end
      end
    end

    pieces.each do |piece|
      return true if piece[0].valid_move?(board, piece[1], destination)
    end

    return false
  end

  def king_checkmated?(board, color)

    # Generate all legal moves player can make
    pieces = []
    # Get all pieces on board
    board.each_with_index do |row, row_index|
      row.each_with_index do |square, column_index|
        unless square.nil?
          if square.color == color
            pieces.push [square, [row_index, column_index]]
          end
        end
      end
    end

    # For each piece, simulate all possible moves and check if check is removed
    pieces.each do |piece|

      origin = piece[1]

      (0...7).each do |row|
        (0...7).each do |column|

          destination = [row, column]

          if piece[0].valid_move?(board, origin, destination)
            return false unless simulate_move(board, piece[0], origin, destination, color)
          end

        end
      end
    end
    
    return true
  end

  def simulate_move(board, piece, origin, destination, color)
    # Deep copy the board
    local_board = Marshal.load(Marshal.dump(board))
    # Make hypothetical move
    move_piece(local_board, piece, origin, destination, false)
    # Check for check
    return king_checked?(local_board, color)   
  end
end

game = Chess.new
game.start
