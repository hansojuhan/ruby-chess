require 'pry-byebug'
require_relative 'chess_pieces'

class Chess
  attr_reader :board
  attr_accessor :history

  # Chess board rows
  ROWS = 'abcdefgh'

  def initialize
    # Initialise the board as an 8x8 array
    @board = Array.new(8) { Array.new(8) }

    # History containing all game moves done
    @history = []
  end
  
  # def get_piece(coordinates)
  #   @board[8 - coordinates[1].to_i][ROWS.index(coordinates[0])]
  # end

#   def set_piece(piece, destination)
#     # Input will be an array [6, 1], so it's easy
#     self.board[destination[0]][destination[1]] = piece

# binding.pry
#     puts "asdf"
#   end


  def set_piece(piece, coordinates)
    # Parse coordinates both as letters or numbers
    board_column = ROWS.index(coordinates[0])
    board_row = 8 - coordinates[1].to_i

    @board[board_row][board_column] = piece
  end

  # Render the current state of the @board with letters and numbers
  def render_board

    print `clear`
    print "\n"

    board.each_with_index do |row, row_number|
      # Print row numbers
      print " #{row_number} "
      # print " #{8 - row_number} " TODO

      # If square is nil, print out dot, if object, print out object's symbol
      row.each do |square|
        print square.nil? ? " · " : " #{square.symbol} "
      end
      
      print "\n"
    end

    # Letters underneath
    print "    0  1  2  3  4  5  6  7\n\n"
    # print "    a  b  c  d  e  f  g  h\n\n" TODO

    render_history
  end

  def make_move
    # Get two coordinates:
    origin = parse_input_basic_array "From:"
    destination = parse_input_basic_array "To:"

    # Find piece
    piece = get_piece_basic(origin)
    opponents_piece = get_piece_basic(destination)

    # Move it if move is valid
    if !piece.nil? && piece.valid_move?(board, origin, destination)

      # If destination includes an opponent's piece, take it, otherwise move
      unless opponents_piece.nil?
        take_piece(piece, opponents_piece, origin, destination)
      else
        move_piece(piece, origin, destination)
      end

      # Finish move, record history
      update_history(piece, opponents_piece, origin, destination)
      move_made = true
    end
  end

  def render_history
    history.each_with_index do |round, round_number|
      print "#{round_number + 1}) #{round[0]},\t#{round[1]}\n"
    end
  end

  def update_history(piece, opponents_piece = nil, origin, destination)
    # Writes up history in chess algebraic notation
    # Rules:
    # 1. To write a move, give name of piece and destination square. 
    # 2. If piece captured, include x for "captures" before the destination square.
    # 2.1. When a pawn makes a capture, always include the originating file, as in fxe4 and gxf6 above.
   
    # Symbols:
    # x: captures
    # 0-0: kingside castle
    # 0-0-0: queenside castle
    # +: check
    #: checkmate

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
    # add +, # in case of check, mate (TODO later)

    # If first move of turn, needs to be added as element 1 of array length 2 into the main array
    # If second move of turn, second element of array length 2
    # test_array = [["Nc5","f5"],["e4","fxe4"],["Nxe4","Nf6"],["d2",""]]

    # 3 options:
    # empty (first move of the game)
    if history.empty?
      # Create a new 2-element array
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

  def coordinates_to_string(coordinates)
    # Input will be [1, 3] (row, column)
    output = ""
    # Output should be "d7"
    output << ROWS[coordinates[1]]
    output << (8 - coordinates[1]).to_s
    
    return output
  end

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
  end

  def move_piece(piece, origin, destination)
    # Need to move piece into the array position at destination
    board[destination[0]][destination[1]] = piece
    # And remove from origin
    board[origin[0]][origin[1]] = nil
    # Increment piece's own move counter
    piece.moves_done += 1
  end

  def get_piece_basic(array)
    board[array[0]][array[1]]
  end

  def start_new_game
    # To start a new game, black and white pieces have to be
    # generated and put on the board, move history needs to 
    # be reset.

    # Start with white
    # set_piece(Pawn.new(:white),["a", 2])
    # set_piece(Pawn.new(:white),["b", 2])
    # set_piece(Pawn.new(:white),["c", 2])
    # set_piece(Pawn.new(:white),["d", 2])
    set_piece(Pawn.new(:white),["e", 2])
    # set_piece(Pawn.new(:white),["f", 2])
    # set_piece(Pawn.new(:white),["g", 2])
    # set_piece(Pawn.new(:white),["h", 2])

    # set_piece(Rook.new(:white),["a",1])
    # set_piece(Knight.new(:white),["b",1])
    # set_piece(Bishop.new(:white),["c",1])
    # set_piece(Queen.new(:white),["d",1])
    # set_piece(King.new(:white),["e",1])
    # set_piece(Bishop.new(:white),["f",1])
    # set_piece(Knight.new(:white),["g",1])
    # set_piece(Rook.new(:white),["h",1])

    # Then black
    # set_piece(Pawn.new(:black),["a", 7])
    # set_piece(Pawn.new(:black),["b", 7])
    # set_piece(Pawn.new(:black),["c", 7])
    # set_piece(Pawn.new(:black),["d", 7])
    # set_piece(Pawn.new(:black),["e", 7])
    # set_piece(Pawn.new(:black),["f", 7])
    # set_piece(Pawn.new(:black),["g", 7])
    # set_piece(Pawn.new(:black),["h", 7])

    # set_piece(Rook.new(:black),["a",8])
    # set_piece(Rook.new(:black),["h",8])
    # set_piece(Knight.new(:black),["b",8])
    # set_piece(Knight.new(:black),["g",8])
    # set_piece(Bishop.new(:black),["f",8])
    # set_piece(Bishop.new(:black),["c",8])
    # set_piece(Queen.new(:black),["d",8])
    # set_piece(King.new(:black),["e",8])

    # Reset history
    self.history = []
  end

  private
  def parse_input_basic_array(query_text)
    input_gotten = false
    until input_gotten do
      
      print "#{query_text}\t"
      input = gets.chomp

      if input.length == 2 && input[0].to_i.between?(0,7) && input[1].to_i.between?(0,7)
        result = input.split("")

        result = result.map { |e| e.to_i }
        # temp = result[1]
        # result[1] = result[0]
        # result[0] = temp
        return result
      else
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

      if input.length == 2 && ('abcdefgh').include?(input[0]) && input[1].to_i.between?(1,8)
        result = input.split("")
        result[1] = result[1].to_i
        return result
      else
        render_board
      end
    end
  end

end

game = Chess.new

game.start_new_game
game.render_board

loop do
  game.make_move
  game.render_board
end
