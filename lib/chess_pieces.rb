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
      moves_done == 0 && 
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
    # 1.1. Moves in a straight line, horizontally or vertically.
    # If one coordinate is same and other is different, movement is a straight line
    if destination[0] == origin[0] && destination[1] != origin[1]
      # Horizontal movement

      # 1.2. Squares between start and end must be empty.
      # Iterate over the squares between origin and destination, checking all of them are nil

      # Sort the range to be smallest->largest, because otherwise #all? will not work
      start_square, end_square = [origin[1], destination[1]].sort

      # Exclude the destination square for now
      if ((start_square+1...end_square).all? { |square| board[origin[0]][square] == nil })

        # 1.3. If an opponent piece is on the end square, it is taken
        # If destination contains a piece (is not nil), check its color
        unless board[destination[0]][destination[1]].nil?

          # Return true if color is different
          if board[destination[0]][destination[1]].color != self.color
            return true
          else
            return false
          end

        else
          return true
        end
      end
      
    elsif destination[0] != origin[0] && destination[1] == origin[1]
      # Vertical movement

      # 1.2. Squares between start and end must be empty.

      start_square, end_square = [origin[0], destination[0]].sort

      # Iterate over the squares between origin and destination, checking all of them are nil
      if ((start_square+1...end_square).all? { |square| board[square][origin[1]] == nil })

        unless board[destination[0]][destination[1]].nil?

          # Return true if color is different
          if board[destination[0]][destination[1]].color != self.color
            return true
          else
            return false
          end

        else
          return true
        end

        # 1.3. If an opponent piece is on the end square, it is taken.
        if board[destination[0]][destination[1]].color != self.color
          return true
        else
          return false
        end
      end
    end

    return false
  end
end

class Bishop < ChessPiece

  def all_squares_nil?(board, origin, destination, x_increment, y_increment)

    x, y = origin[0], origin[1]

    while x != destination[0] && y != destination[1] do

      unless board[x][y].nil? # Exclude origin square
        return false unless (x == origin[0] && y == origin[1])
      end

      x, y = x + x_increment, y + y_increment
    end

    return true
  end

  def movement_diagonal?(origin, destination)
    origin[1] - origin[0] == destination[1] - destination[0] || origin[0] + origin[1] == destination[0] + destination[1]
  end

  def diagonal_move_valid?(board, origin, destination)

    x1, y1 = origin[0], origin[1]
    x2, y2 = destination[0], destination[1]

    x_increment = 1
    y_increment = 1

    # Find the diagonal
    case 
    when x1 < x2 && y1 < y2 # Down right
      # x+1 y+1
    when x1 > x2 && y1 > y2 # Up left
      # x-1 y-1
      x_increment = -1
      y_increment = -1
    when x1 < x2 && y1 > y2 # Down left
      # x+1 y-1
      # x_increment = 1
      y_increment = -1
    when x1 > x2 && y1 < y2 # Up right
      # x-1 y+1
      x_increment = -1
      # y_increment = 1
    end

    return all_squares_nil?(board, origin, destination, x_increment, y_increment)
  end

  def opponent_piece?(board, coordinates)
    board[coordinates[0]][coordinates[1]].color != self.color
  end

  def square_empty?(board, coordinates)
    board[coordinates[0]][coordinates[1]].nil?
  end

  def valid_move?(board, origin, destination)
    # 1.1. Moves in diagonal lines.
    # 1.2. Cannot jump over other pieces.
    # 1.3. If an opponent piece is on the end square, it is taken.

    # If movement is not diagonal, return false immediately
    return false unless movement_diagonal?(origin, destination)

    if diagonal_move_valid?(board, origin, destination)

        # If destination contains a piece (is not nil), check its color
        unless square_empty?(board, destination)

          # Return true if color is different
          if opponent_piece?(board, destination)
            return true
          else
            return false
          end

        else
          return true
        end

    end
      
    return false
  end
end

class Knight < ChessPiece
end

class Queen < ChessPiece
end

class King < ChessPiece
end
