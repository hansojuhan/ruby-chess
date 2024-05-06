require 'pry-byebug'

class Chess
  attr_reader :board

  # Chess board rows
  ROWS = 'abcdefgh'

  def initialize
    # Initialise the board as an 8x8 array
    @board = Array.new(8) { Array.new(8) }

    # Set a pawn at a8 for testing
    @board[0][0] = Pawn.new

    p @board
  end
  
  def get_piece(column, row)
    @board[8 - row][ROWS.index(column)]
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
    @board[8 - row][ROWS.index(column)] = piece

    p @board
  end
end

# Pawn class
class Pawn
  def initialize
    @name = "Pawn"
  end
end

game = Chess.new

# Get what piece is at 'a8' (left upper corner)
p game.get_piece('a', 8)
# Set a piece at 'a1'
game.set_piece(Pawn.new, 'a', 1)
