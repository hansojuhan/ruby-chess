class ChessPiece
  attr_reader :color, :symbol
  attr_accessor :moves_done

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

  def initialize(color)
    @color = color
    @symbol = CHESS_SYMBOLS[@color][self.class.name.downcase.to_sym]

    # Keep track of amount of moves piece has done.
    @moves_done = 0
  end
end

class Pawn < ChessPiece
  # Check if pawn can make this move
  def valid_move?(board, origin, destination)
    # Destination should be empty
    return false unless board[destination[0]][destination[1]].nil?
    
    # Valid moves
    # 1. One square forward (white: decrement row, black: increment row)
    return true if destination[0] == origin[0] - 1

    # 2. Two squares forward, if first move
    return true if destination[0] == origin[0] - 2 && moves_done == 0
  end
end

class Knight < ChessPiece
end

class Bishop < ChessPiece
end

class Rook < ChessPiece
end

class Queen < ChessPiece
end

class King < ChessPiece
end
