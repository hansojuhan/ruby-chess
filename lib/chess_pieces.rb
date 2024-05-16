class ChessPiece
  attr_reader :color, :symbol, :notation_symbol
  attr_accessor :moves_done, :taken

  CHESS_SYMBOLS = {
    white: {
      king: "♔",
      queen: "♕",
      rook: "♖",
      bishop: "♗",
      knight: "♘",
      pawn: "♙"
    },
    black: {
      king: "♚",
      queen: "♛",
      rook: "♜",
      bishop: "♝",
      knight: "♞",
      pawn: "♟︎"
    }
  }

  NOTATION_SYMBOLS = {
    king: "K",
    queen: "Q",
    rook: "R",
    bishop: "B",
    knight: "N",
    pawn: ""
  }

  def initialize(color = :white)
    @color = color
    @symbol = CHESS_SYMBOLS[@color][self.class.name.downcase.to_sym]

    # Symbol for notation
    @notation_symbol = NOTATION_SYMBOLS[self.class.name.downcase.to_sym]

    # Keep track of amount of moves piece has done.
    @moves_done = 0

    # Status, piece is alive or taken
    @taken = false
  end

  # Get move direction: white decrements row, black increments row
  def move_direction(number) 
    self.color == :white ? -number : number
  end

  # Iterate over squares between origin and destination
  # according to movement type
  # And return true if squares are empty
  def all_squares_nil?(board, origin, destination)

    # Set increments
    x_increment, y_increment = set_increments(origin, destination)

    # Start with the orgin square with coordinates x,y
    x, y = origin[0], origin[1]

    # Iterate over squares until destination
    until x == destination[0] && y == destination[1] do

      # If a square is not nil, there is a piece in the way (return false)
      unless board[x][y].nil? 
        return false unless (x == origin[0] && y == origin[1]) # Exclude origin
      end

      # Continue incrementing
      x, y = x + x_increment, y + y_increment
    end

    # All squares were nil, return true
    return true
  end

  # Return true if there's a diagonal between origin and destination
  def movement_diagonal?(origin, destination)
    origin[1] - origin[0] == destination[1] - destination[0] || origin[0] + origin[1] == destination[0] + destination[1]
  end

  # Return true if there's a line between origin and destination
  def movement_orthogonal?(origin, destination)
    destination[0] == origin[0] && destination[1] != origin[1] || destination[0] != origin[0] && destination[1] == origin[1]
  end
  
  def opponent_piece?(board, coordinates)
    board[coordinates[0]][coordinates[1]].color != self.color
  end

  def square_empty?(board, coordinates)
    board[coordinates[0]][coordinates[1]].nil?
  end

  def set_increments(origin, destination)

    x1, y1 = origin[0], origin[1]
    x2, y2 = destination[0], destination[1]

    # Find the type of movement
    if movement_orthogonal?(origin, destination)
      case 
      when x1 == x2 && y1 < y2 # Line horizontal to the right
        x_increment = 0
        y_increment = 1
      when x1 == x2 && y1 > y2 # Line horizontal to the left
        x_increment = 0
        y_increment = -1
      when x1 > x2 && y1 == y2 # Line vertical up
        x_increment = -1
        y_increment = 0
      when x1 < x2 && y1 == y2 # Line vertical down
        x_increment = 1
        y_increment = 0
      end
    elsif movement_diagonal?(origin, destination)
      case
      when x1 < x2 && y1 < y2 # Diagonal Down right
        x_increment = 1
        y_increment = 1
      when x1 > x2 && y1 > y2 # Diagonal Up left
        x_increment = -1
        y_increment = -1
      when x1 < x2 && y1 > y2 # Diagonal Down left
        x_increment = 1
        y_increment = -1
      when x1 > x2 && y1 < y2 # Diagonal Up right
        x_increment = -1
        y_increment = 1
      end
    end
    
    return x_increment, y_increment
  end

  def validate_move(board, origin, destination)
      # Check if all squares in the movement are empty
      if all_squares_nil?(board, origin, destination)
        # If destination contains a piece (is not nil), check its color
        unless square_empty?(board, destination)
          # Return true if color is different
          return true if opponent_piece?(board, destination)
        else
          return true
        end
    end
  end
end

class Pawn < ChessPiece
  # Check if pawn can make this move
  def valid_move?(board, origin, destination)

    # Valid moves
    # 1. One square forward (white: decrement row, black: increment row)
    if 
      destination[0] == origin[0] + move_direction(1) && 
      destination[1] == origin[1] &&
      board[destination[0]][destination[1]].nil?

      return true
    end

    # 2. Two squares forward, if first move
    if 
      destination[0] == origin[0] + move_direction(2) && 
      destination[1] == origin[1] && 
      moves_done == 0 && # First move
      board[origin[0] + move_direction(1)][origin[1]].nil? && # No piece in the middle
      board[destination[0]][destination[1]].nil?

      return true
    end
    

    # 3. Take: enemy piece is diagonal
    if 
      destination[0] == origin[0] + move_direction(1) && 
      (destination[1] == origin[1] + move_direction(1) || destination[1] == origin[1] - move_direction(1)) &&
      (!board[destination[0]][destination[1]].nil? && board[destination[0]][destination[1]].color != self.color)

      return true
    end

    return false
  end
end

class Rook < ChessPiece
  def valid_move?(board, origin, destination)
    # 1.1. Moves in diagonal lines.
    # 1.2. Cannot jump over other pieces.
    # 1.3. If an opponent piece is on the end square, it is taken.

    # If movement is not orthogonal (in lines), return false
    return false unless movement_orthogonal?(origin, destination)

    # Check other rules
    if validate_move(board, origin, destination)
      return true
    else
      return false
    end
  end
end

class Bishop < ChessPiece
  def valid_move?(board, origin, destination)
    # 1.1. Moves in diagonal lines.
    # 1.2. Cannot jump over other pieces.
    # 1.3. If an opponent piece is on the end square, it is taken.

    # If movement is not diagonal, return false
    return false unless movement_diagonal?(origin, destination)

    # Check other rules
    if validate_move(board, origin, destination)
      return true
    else
      return false
    end
  end
end

class Queen < ChessPiece
  def valid_move?(board, origin, destination)
    # 1.1. Moves straight and in diagonal.
    # 1.2. Cannot jump over other pieces.
    # 1.3. If an opponent piece is on the end square, it is taken.
  
    return false unless movement_diagonal?(origin, destination) || movement_orthogonal?(origin, destination)

    # Check other rules
    if validate_move(board, origin, destination)
      return true
    else
      return false
    end
  end
end

class Knight < ChessPiece
end

class King < ChessPiece
end
