require 'pry-byebug'
require_relative 'chess_pieces'

class Chess
  attr_reader :board
  attr_accessor :history

  # Chess board rows
  ROWS = 'abcdefgh'
  # Symbols


  def initialize
    # Initialise the board as an 8x8 array
    @board = Array.new(8) { Array.new(8) }

    # History containing all game moves done
    @history = []
  end
  
  def get_piece(coordinates)
    @board[8 - coordinates[1].to_i][ROWS.index(coordinates[0])]
  end

  def set_piece(piece, coordinates)
    # Chess board has rows and columns
    # Row 1 is the end of the board where white begins
    # Column 1 starts from left to right

    # Example: 1, a - Row 1, Column 1 - array[7][0]
    # Example: 5, h - Row 5, Column h - array[3][7]

    # Columns a,b,c,d,e,f,g,h
    # Rows 1,2,3,4,5,6,7,8

    # Find the right array place according to input coordinates
    
    # I moved my pawn from d2 -> d3
    # Input: pawn, d, 3
    # Output: board with pawn at board[5][3]

    # Parse coordinates both as letters or numbers
    if coordinates[0].is_a? Integer
      board_column = coordinates[0]
    elsif coordinates[0].is_a? String
      board_column = ROWS.index(coordinates[0])
    end

    if coordinates[1].is_a? Integer
      board_row = 8 - coordinates[1]
    elsif coordinates[1].is_a? String
      board_row = 8 - coordinates[1].to_i
    end

    @board[board_row][board_column] = piece
  end

  # Render the current state of the @board with letters and numbers
  def render_board

    print `clear`
    print "\n"

    board.each_with_index do |row, row_number|
      # Print row numbers
      print " #{8 - row_number} "

      # If square is nil, print out dot, if object, print out object's symbol
      row.each do |square|
        print square.nil? ? " · " : " #{square.symbol} "
      end
      
      print "\n"
    end

    # Letters underneath
    print "    a  b  c  d  e  f  g  h\n\n"
  end

  def make_move
    # Get two coordinates:
    # First which piece to move, then where to move it
    origin = parse_input "From:"
    destination = parse_input "To:"

    # Later will check this before, but
    # Take the object from origin
    # And put it at destination
    piece = get_piece(origin)

    set_piece(piece, destination)
    set_piece(nil, origin)
  end

  def start_new_game
    # To start a new game, black and white pieces have to be
    # generated and put on the board, move history needs to 
    # be reset.

    # Start with white
    for i in 0...8
      set_piece(Pawn.new(:white),[i, 2])
    end
    set_piece(Rook.new(:white),["a",1])
    set_piece(Rook.new(:white),["h",1])
    set_piece(Knight.new(:white),["b",1])
    set_piece(Knight.new(:white),["g",1])
    set_piece(Bishop.new(:white),["f",1])
    set_piece(Bishop.new(:white),["c",1])
    set_piece(Queen.new(:white),["d",1])
    set_piece(King.new(:white),["e",1])

    # Then black
    for i in 0...8
      set_piece(Pawn.new(:black),[i, 7])
    end
    set_piece(Rook.new(:black),["a",8])
    set_piece(Rook.new(:black),["h",8])
    set_piece(Knight.new(:black),["b",8])
    set_piece(Knight.new(:black),["g",8])
    set_piece(Bishop.new(:black),["f",8])
    set_piece(Bishop.new(:black),["c",8])
    set_piece(Queen.new(:black),["d",8])
    set_piece(King.new(:black),["e",8])

    # Reset history
    self.history = []
  end

  private
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

# Get what piece is at 'a8' (left upper corner)
# p game.get_piece('a', 8)
# # Set a piece at 'a1'
# game.set_piece(Pawn.new, 'a', 1)

game.start_new_game
game.render_board

game.make_move
game.render_board

# To do:
# Refactor getting coordinates so that they would be held in an array of 2
# [column, row]

# Coordinates should be variables of the objects
