require 'spec_helper'
require_relative '../lib/chess.rb'
require_relative '../lib/chess_pieces.rb'

RSpec.describe '.Bishop' do
  describe '#valid_move?' do

    context 'when moving diagonally' do
      it 'up to the right returns true' do
        # Set piece
        bishop = Bishop.new 
  
        # Set board
        board = Array.new(8) { Array.new(8) }
        board[7][0] = bishop
  
        # Set origin and destination
        origin = [7,0]
        destination = [0,7]
        
        # This should return true, since it's a valid move
        expect(bishop.valid_move?(board, origin, destination)).to be true
      end
 
      it 'down to the right returns true' do
        # Set piece
        bishop = Bishop.new 
  
        # Set board
        board = Array.new(8) { Array.new(8) }
        board[0][0] = bishop
  
        # Set origin and destination
        origin = [0,0]
        destination = [7,7]
        
        # This should return true, since it's a valid move
        expect(bishop.valid_move?(board, origin, destination)).to be true
      end

      it 'up to the left returns true' do
        # Set piece
        bishop = Bishop.new 
  
        # Set board
        board = Array.new(8) { Array.new(8) }
        board[7][7] = bishop
  
        # Set origin and destination
        origin = [7,7]
        destination = [0,0]
        
        # This should return true, since it's a valid move
        expect(bishop.valid_move?(board, origin, destination)).to be true
      end      

      it 'down to the left returns true' do
        # Set piece
        bishop = Bishop.new 
  
        # Set board
        board = Array.new(8) { Array.new(8) }
        board[0][7] = bishop
  
        # Set origin and destination
        origin = [0,7]
        destination = [7,0]
        
        # This should return true, since it's a valid move
        expect(bishop.valid_move?(board, origin, destination)).to be true
      end
    end

    context 'when not moving diagonally' do
      it 'in line returns false' do
        # Set piece
        bishop = Bishop.new 

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[0][0] = bishop
  
        # Set origin and destination
        origin = [0,0]
        destination = [0,2]
        
        expect(bishop.valid_move?(board, origin, destination)).to be false
      end

      it 'to a random position returns false' do
        # Set piece
        bishop = Bishop.new 

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[0][0] = bishop
  
        # Set origin and destination
        origin = [0,0]
        destination = [5,6]
        
        # This should return true, since it's a valid move
        expect(bishop.valid_move?(board, origin, destination)).to be false
      end
    end
    
    context 'when squares between start and end contain pieces' do
      it 'up to the right returns false' do
        # Set piece
        bishop = Bishop.new 
  
        # Set board
        board = Array.new(8) { Array.new(8) }
        board[2][4] = bishop
  
        # Set piece in the middle
        board[1][5] = Pawn.new

        # Set origin and destination
        origin = [2,4]
        destination = [0,6]
        
        expect(bishop.valid_move?(board, origin, destination)).to be false
      end
 
      it 'down to the right returns false' do
        # Set piece
        bishop = Bishop.new 
  
        # Set board
        board = Array.new(8) { Array.new(8) }
        board[0][0] = bishop
  
        # Set piece in the middle
        board[5][5] = Pawn.new

        # Set origin and destination
        origin = [0,0]
        destination = [7,7]
        
        expect(bishop.valid_move?(board, origin, destination)).to be false
      end

      it 'up to the left returns false' do
        # Set piece
        bishop = Bishop.new 
  
        # Set board
        board = Array.new(8) { Array.new(8) }
        board[5][7] = bishop
  
        # Set piece in the middle
        board[3][5] = Pawn.new

        # Set origin and destination
        origin = [5,7]
        destination = [2,4]
        
        expect(bishop.valid_move?(board, origin, destination)).to be false
      end      

      it 'down to the left returns false' do
        # Set piece
        bishop = Bishop.new 
  
        # Set board
        board = Array.new(8) { Array.new(8) }
        board[0][6] = bishop
  
        # Set piece in the middle
        board[1][5] = Pawn.new

        # Set origin and destination
        origin = [0,6]
        destination = [2,4]
        
        expect(bishop.valid_move?(board, origin, destination)).to be false
      end
    end

    context 'if piece is on the end square' do
      it 'opponent piece, returns true' do
        # Set piece
        bishop = Bishop.new(:white)

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[0][0] = bishop
  
        board[7][7] = Pawn.new(:black)

        # Set origin and destination
        origin = [0,0]
        destination = [7,7]
        
        # This should return true, since it's a valid move
        expect(bishop.valid_move?(board, origin, destination)).to be true
      end

      it 'own piece, returns false' do
        # Set piece
        bishop = Bishop.new(:white)

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[0][0] = bishop
  
        board[2][2] = Pawn.new(:white)

        # Set origin and destination
        origin = [0,0]
        destination = [2,2]
        
        # This should return true, since it's a valid move
        expect(bishop.valid_move?(board, origin, destination)).to be false
      end
    end
  end
end
