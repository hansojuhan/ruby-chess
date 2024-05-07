class ChessPiece
  attr_reader :color, :symbol

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
  end
end

class Pawn < ChessPiece
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

# pawn = Pawn.new(:white)
# king = King.new(:black)
# p pawn
# p king
