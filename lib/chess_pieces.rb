class ChessPiece
  attr_reader :color, :symbol
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

  def initialize(color)
    @color = color
    @symbol = CHESS_SYMBOLS[@color][self.class.name.downcase.to_sym]

    # Symbol for notation
    @notation_symbol = NOTATION_SYMBOLS[self.class.name.downcase.to_sym]

    # Keep track of amount of moves piece has done.
    @moves_done = 0

    # Status, piece is alive or taken
    @taken = false
  end
end

class Pawn < ChessPiece
  # Check if pawn can make this move
  def valid_move?(board, origin, destination)
    # Valid moves
    # 1. One square forward (white: decrement row, black: increment row)
    if 
      destination[0] == origin[0] - 1 && 
      destination[1] == origin[1] &&
      board[destination[0]][destination[1]].nil?
8
      return true
    end

    # 2. Two squares forward, if first move
    if 
      destination[0] == origin[0] - 2 && 
      destination[1] == origin[1] && 
      moves_done == 0 && 
      board[destination[0]][destination[1]].nil?

      return true
    end

    # 3. Take: enemy piece is diagonal
    if 
      destination[0] == origin[0] - 1 && 
      (destination[1] == origin[1] - 1 || destination[1] == origin[1] + 1) &&
      (!board[destination[0]][destination[1]].nil? && board[destination[0]][destination[1]].color != self.color)

      return true
    end

    return false
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
