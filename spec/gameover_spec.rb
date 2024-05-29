require 'spec_helper'
require_relative '../lib/chess.rb'
require_relative '../lib/chess_pieces.rb'

RSpec.describe 'Gameover' do
  describe 'Check' do

    context 'when moving' do
      it 'so that opponent king is checked, return true' do

        chess = Chess.new

        chess.set_piece(King.new(:white),["a", 1])
        chess.set_piece(Queen.new(:black),["b", 8])

        origin = [0,1]
        destination = [0,0]

        black_queen = chess.get_piece_basic(origin)
        white_king = chess.get_piece_basic([7,0])

        chess.move_piece(chess.board, black_queen, origin, destination)

        expect(chess.king_checked?(chess.board, white_king.color)).to be true
      end

      it 'so that own king is checked, return true' do

        chess = Chess.new

        chess.set_piece(King.new(:white),["a", 1])
        chess.set_piece(Rook.new(:white),["a", 2])
        chess.set_piece(Queen.new(:black),["a", 8])

        origin = [6,0]
        destination = [6,1]

        white_rook = chess.get_piece_basic(origin)
        chess.move_piece(chess.board, white_rook, origin, destination)

        white_king = chess.get_piece_basic([7,0])

        expect(chess.king_checked?(chess.board, white_king.color)).to be true
      end
    end

  end

  describe 'Checkmates' do
    it 'Arabian mate' do

      chess = Chess.new
      
      # Set pieces
      chess.set_piece(Knight.new(:white),["f",6])
      chess.set_piece(Rook.new(:white),["g",1])
      chess.set_piece(King.new(:white),["h",1])
      chess.set_piece(King.new(:black),["h",8])

      origin = [7,6]
      destination = [0,6]

      # Move white rook to g8 for the checkmate
      white_rook = chess.get_piece_basic(origin)      
      chess.move_piece(chess.board, white_rook, origin, destination)

      # Checkmate
      black_king = chess.get_piece_basic([0,7])
      
      expect(chess.king_checkmated?(chess.board, black_king.color)).to be true
    end

    it 'Fools mate' do
      
      # White pawn f3
      # Black pawn e6
      # White pawn g4
      # Black queen h4
      
      # Set pieces
      chess = Chess.new
      chess.initialize_game

      white_king = chess.get_piece_basic([7,4])

      chess.move_piece(chess.board, chess.get_piece_basic([6,5]), [6,5], [5,5])
      expect(chess.king_checkmated?(chess.board, white_king.color)).to be false

      chess.move_piece(chess.board, chess.get_piece_basic([1,4]), [1,4], [2,4])
      expect(chess.king_checkmated?(chess.board, white_king.color)).to be false

      chess.move_piece(chess.board, chess.get_piece_basic([6,6]), [6,6], [4,6])

      expect(chess.king_checkmated?(chess.board, white_king.color)).to be false
      chess.move_piece(chess.board, chess.get_piece_basic([0,3]), [0,3], [4,7])
      
      expect(chess.king_checkmated?(chess.board, white_king.color)).to be true
    end

    it 'Scholars mate' do
      
      # Set pieces
      chess = Chess.new
      chess.initialize_game

      black_king = chess.get_piece_basic([0,4])

      chess.move_piece(chess.board, chess.get_piece_basic([6,4]), [6,4], [4,4])
      expect(chess.king_checkmated?(chess.board, black_king.color)).to be false

      chess.move_piece(chess.board, chess.get_piece_basic([1,4]), [1,4], [3,4])
      expect(chess.king_checkmated?(chess.board, black_king.color)).to be false

      chess.move_piece(chess.board, chess.get_piece_basic([7,5]), [7,5], [4,2])
      expect(chess.king_checkmated?(chess.board, black_king.color)).to be false

      chess.move_piece(chess.board, chess.get_piece_basic([0,5]), [0,5], [3,2])
      expect(chess.king_checkmated?(chess.board, black_king.color)).to be false

      chess.move_piece(chess.board, chess.get_piece_basic([7,3]), [7,3], [3,7])
      expect(chess.king_checkmated?(chess.board, black_king.color)).to be false

      chess.move_piece(chess.board, chess.get_piece_basic([0,6]), [0,6], [2,5])
      expect(chess.king_checkmated?(chess.board, black_king.color)).to be false

      chess.move_piece(chess.board, chess.get_piece_basic([3,7]), [3,7], [1,5])

      expect(chess.king_checkmated?(chess.board, black_king.color)).to be true
    end

  end
end
