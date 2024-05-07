require 'pry-byebug'
require_relative 'chess_pieces'

class Chess
  attr_reader :board

  # Chess board rows
  ROWS = 'abcdefgh'
  # Symbols


  def initialize
    # Initialise the board as an 8x8 array
    @board = Array.new(8) { Array.new(8) }
  end
  
  def get_piece(column, row)
    @board[8 - row.to_i][ROWS.index(column)]
  end

  def set_piece(piece, column, row)
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
    if column.is_a? Integer
      board_column = column
    elsif column.is_a? String
      board_column = ROWS.index(column)
    end

    if row.is_a? Integer
      board_row = 8 - row
    elsif row.is_a? String
      board_row = 8 - row.to_i
    end

    @board[board_row][board_column] = piece
  end

  # Render the current state of the @board with letters and numbers
  def render_board
    print `clear`

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
    piece = get_piece(origin[0], origin[1])

    set_piece(piece, destination[0], destination[1])
    set_piece(nil, origin[0], origin[1])
    # puts piece
  end

  def start_new_game
    # To start a new game, black and white pieces have to be
    # generated and put on the board, move history needs to 
    # be reset.

    # Start with white
    for i in 0...8
      set_piece(Pawn.new, i, 2)
    end
    set_piece(Rook.new,"a",1)
    set_piece(Rook.new,"h",1)
    set_piece(Knight.new,"b",1)
    set_piece(Knight.new,"g",1)
    set_piece(Bishop.new,"f",1)
    set_piece(Bishop.new,"c",1)
    set_piece(Queen.new,"d",1)
    set_piece(King.new,"e",1)

  end

  private
  # Returns input if they are coordinates on the chess board
  # For example, a1 or h8
  def parse_input(query_text)
    input_gotten = false
    until input_gotten do
      
      print "#{query_text}\t"
      input = gets.chomp

      if input.length == 2 && ('abcdefgh').include?(input[0]) && input[1].to_i.between?(1,8)
        return input
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

# To do:
# Refactor getting coordinates so that they would be held in an array of 2
# [column, row]

# Coordinates should be variables of the objects
