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

        chess.move_piece(black_queen, origin, destination)

        expect(chess.king_checked?(chess.board, white_king.color)).to be true
      end

      it 'so that own king is checked, return true' do

        chess = Chess.new

        chess.set_piece(King.new(:white),["a", 1])
        chess.set_piece(Rook.new(:white),["a", 2])
        chess.set_piece(Queen.new(:black),["a", 8])

        origin = [6,0]
        destination = [6,1]

        binding.pry
        white_rook = chess.get_piece_basic(origin)
        chess.move_piece(white_rook, origin, destination)

        white_king = chess.get_piece_basic([7,0])

        expect(chess.king_checked?(chess.board, white_king.color)).to be true
      end
    end

  end
end
