require 'spec_helper'
require_relative '../lib/chess.rb'
require_relative '../lib/chess_pieces.rb'

RSpec.describe '.Rook' do
  describe '#valid_move?' do

    context 'when moving in a straight line' do
      it 'horizontally returns true' do
        # Set rook
        rook = Rook.new 
  
        # Set board
        board = Array.new(8) { Array.new(8) }
        board[0][0] = rook
  
        # Set origin and destination
        origin = [0,0]
        destination = [0,7]
        
        # This should return true, since it's a valid move
        expect(rook.valid_move?(board, origin, destination)).to be true
      end
 
      it 'vertically returns true' do
        # Set rook
        rook = Rook.new 

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[0][0] = rook
  
        # Set origin and destination
        origin = [0,0]
        destination = [5,0]
        
        # This should return true, since it's a valid move
        expect(rook.valid_move?(board, origin, destination)).to be true
      end
    end

    context 'when not moving in a straight line' do
      it 'diagonally returns false' do
        # Set rook
        rook = Rook.new 

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[0][0] = rook
  
        # Set origin and destination
        origin = [0,0]
        destination = [2,2]
        
        # This should return true, since it's a valid move
        expect(rook.valid_move?(board, origin, destination)).to be false
      end

      it 'to a random position not in a straight line returns false' do
        # Set rook
        rook = Rook.new 

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[0][0] = rook
  
        # Set origin and destination
        origin = [0,0]
        destination = [5,6]
        
        # This should return true, since it's a valid move
        expect(rook.valid_move?(board, origin, destination)).to be false
      end
    end
    
    context 'when squares between start and end contain pieces' do
      it 'moving horizontally to the right return false' do
        # Set rook
        rook = Rook.new 

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[0][0] = rook
  
        board[0][2] = Pawn.new
        board[0][4] = Bishop.new

        # Set origin and destination
        origin = [0,0]
        destination = [0,7]
        
        # This should return true, since it's a valid move
        expect(rook.valid_move?(board, origin, destination)).to be false
      end

      it 'moving horizontally to the left return false' do
        # Set rook
        rook = Rook.new 

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[1][7] = rook
  
        board[1][5] = Pawn.new

        # Set origin and destination
        origin = [1,7]
        destination = [1,4]
        
        # This should return true, since it's a valid move
        expect(rook.valid_move?(board, origin, destination)).to be false
      end

      it 'moving vertically down return false' do
        # Set rook
        rook = Rook.new 

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[0][0] = rook
  
        board[1][0] = Pawn.new

        # Set origin and destination
        origin = [0,0]
        destination = [2,0]
        
        # This should return true, since it's a valid move
        expect(rook.valid_move?(board, origin, destination)).to be false
      end

      it 'moving vertically up return false' do
        # Set rook
        rook = Rook.new 

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[7][4] = rook
  
        board[5][4] = Pawn.new

        # Set origin and destination
        origin = [7,4]
        destination = [2,4]
        
        # This should return true, since it's a valid move
        expect(rook.valid_move?(board, origin, destination)).to be false
      end
    end

    context 'if piece is on the end square' do
      it 'opponent piece, returns true' do
        # Set rook
        rook = Rook.new(:white)

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[0][0] = rook
  
        board[0][2] = Pawn.new(:black)

        # Set origin and destination
        origin = [0,0]
        destination = [0,2]
        
        # This should return true, since it's a valid move
        expect(rook.valid_move?(board, origin, destination)).to be true
      end

      it 'own piece, returns false' do
        # Set rook
        rook = Rook.new(:white)

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[0][0] = rook
  
        board[0][2] = Pawn.new(:white)

        # Set origin and destination
        origin = [0,0]
        destination = [0,2]
        
        # This should return true, since it's a valid move
        expect(rook.valid_move?(board, origin, destination)).to be false
      end
    end
  end
end
