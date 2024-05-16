require 'spec_helper'
require_relative '../lib/chess.rb'
require_relative '../lib/chess_pieces.rb'

RSpec.describe '.Pawn' do
  describe '#valid_move?' do

    context 'when moving' do
      it 'one square returns true for white pawn' do
        # Set pawn
        pawn = Pawn.new(:white)
  
        # Set board
        board = Array.new(8) { Array.new(8) }
        board[6][5] = pawn
  
        # Set origin and destination
        origin = [6,5]
        destination = [5,5]
        
        # This should return true, since it's a valid move
        expect(pawn.valid_move?(board, origin, destination)).to be true
      end
 
      it 'one square returns true for black pawn' do
        # Set pawn
        pawn = Pawn.new(:black)

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[1][2] = pawn
  
        # Set origin and destination
        origin = [1,2]
        destination = [2,2]
        
        # This should return true, since it's a valid move
        expect(pawn.valid_move?(board, origin, destination)).to be true
      end
    end

    context 'during first move, moving' do
      it 'two squares returns true for white pawn' do
        # Set pawn
        pawn = Pawn.new 

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[6][5] = pawn
  
        # Set origin and destination
        origin = [6,5]
        destination = [4,5]
        
        # This should return true, since it's a valid move
        expect(pawn.valid_move?(board, origin, destination)).to be true
      end

      it 'two squares returns true for black pawn' do
        # Set pawn
        pawn = Pawn.new(:black)

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[1][1] = pawn
  
        # Set origin and destination
        origin = [1,1]
        destination = [3,1]
        
        # This should return true, since it's a valid move
        expect(pawn.valid_move?(board, origin, destination)).to be true
      end
    end
    
    context 'when squares between start and end contain pieces' do
      it 'moving one square for white pawn, returns false' do
        # Set pawn
        pawn = Pawn.new(:white)

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[6][0] = pawn
  
        board[5][0] = Rook.new

        # Set origin and destination
        origin = [6,0]
        destination = [5,0]
        
        # This should return true, since it's a valid move
        expect(pawn.valid_move?(board, origin, destination)).to be false
      end

      it 'moving one square for black pawn, returns false' do
        # Set pawn
        pawn = Pawn.new(:black)

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[1][2] = pawn
  
        board[2][2] = Pawn.new

        # Set origin and destination
        origin = [1,2]
        destination = [2,2]
        
        # This should return true, since it's a valid move
        expect(pawn.valid_move?(board, origin, destination)).to be false
      end

      it 'moving two squares for white pawn, returns false' do
        # Set pawn
        pawn = Pawn.new(:white)

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[6][5] = pawn
  
        board[5][5] = Pawn.new

        # Set origin and destination
        origin = [6,5]
        destination = [4,5]
        
        # This should return true, since it's a valid move
        expect(pawn.valid_move?(board, origin, destination)).to be false
      end

      it 'moving two squares for black pawn, returns false' do
        # Set pawn
        pawn = Pawn.new(:black)

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[1][4] = pawn
  
        board[2][4] = Pawn.new

        # Set origin and destination
        origin = [1,4]
        destination = [3,4]
        
        # This should return true, since it's a valid move
        expect(pawn.valid_move?(board, origin, destination)).to be false
      end
    end

    context 'when taking another piece' do
      it 'white pawn, if opponent piece is in diagonal, returns true' do
        # Set pawn
        pawn = Pawn.new(:white)

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[6][0] = pawn
  
        board[5][1] = Pawn.new(:black)

        # Set origin and destination
        origin = [6,0]
        destination = [5,1]
        
        # This should return true, since it's a valid move
        expect(pawn.valid_move?(board, origin, destination)).to be true
      end

      it 'white pawn, if own piece is in diagonal, returns false' do
        # Set pawn
        pawn = Pawn.new(:white)

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[6][0] = pawn
  
        board[5][1] = Pawn.new(:white)

        # Set origin and destination
        origin = [6,0]
        destination = [5,1]
        
        # This should return true, since it's a valid move
        expect(pawn.valid_move?(board, origin, destination)).to be false
      end

      it 'black pawn, if opponent piece is in diagonal, returns true' do
        # Set pawn
        pawn = Pawn.new(:black)

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[2][0] = pawn
  
        board[3][1] = Pawn.new(:white)

        # Set origin and destination
        origin = [2,0]
        destination = [3,1]
        
        # This should return true, since it's a valid move
        expect(pawn.valid_move?(board, origin, destination)).to be true
      end

      it 'black pawn, if own piece is in diagonal, returns false' do
        # Set pawn
        pawn = Pawn.new(:black)

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[6][0] = pawn
  
        board[5][1] = Pawn.new(:black)

        # Set origin and destination
        origin = [6,0]
        destination = [5,1]
        
        # This should return true, since it's a valid move
        expect(pawn.valid_move?(board, origin, destination)).to be false
      end
    end
  end
end
