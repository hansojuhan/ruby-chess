require 'spec_helper'
require_relative '../lib/chess.rb'
require_relative '../lib/chess_pieces.rb'

RSpec.describe '.King' do
  describe '#valid_move?' do

    # King has 8 potential destinations
    # If origin is 4,4, these are, clockwise
    # 1)  3,3
    # 2)  3,4
    # 3)  3,5
    # 4)  4,3
    # 5)  4,5
    # 6)  5,3
    # 7)  5,4
    # 8)  5,5

    context 'when moving to a destination' do
      it 'return true, when moving to a valid destination' do
        # Set king
        king = King.new
  
        # Set board
        board = Array.new(8) { Array.new(8) }
        board[4][4] = king
  
        # Set origin and destination
        origin = [4,4]
        destinations = [[3,3],[3,4],[3,5],[4,3],[4,5],[5,3],[5,4],[5,5]]
        
        destinations.each do |destination|
          # This should return true, since it's a valid move
          expect(king.valid_move?(board, origin, destination)).to be true
        end
      end

      it 'returns false, when moving to a nonvalid destination' do
        # Set king
        king = King.new
  
        # Set board
        board = Array.new(8) { Array.new(8) }
        board[4][4] = king
  
        # Set origin and destination
        origin = [4,4]
        destinations = [[0,0],[0,1],[7,7],[100,10],[-1,-8],[5,1],[6,4],[3,7]]
        
        destinations.each do |destination|
          # This should return true, since it's a valid move
          expect(king.valid_move?(board, origin, destination)).to be false
        end
      end
      
    end

    context 'when destination contains' do
      it 'opponent piece, returns true' do
        # Set king
        king = King.new(:white)

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[4][4] = king
  
        board[5][5] = Pawn.new(:black)

        # Set origin and destination
        origin = [4,4]
        destination = [5,5]
        
        # This should return true, since it's a valid move
        expect(king.valid_move?(board, origin, destination)).to be true
      end

      it 'own piece, returns false' do
        # Set king
        king = King.new(:white)

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[4][4] = king
  
        board[5][5] = Pawn.new(:white)

        # Set origin and destination
        origin = [4,4]
        destination = [5,5]
        
        # This should return true, since it's a valid move
        expect(king.valid_move?(board, origin, destination)).to be false
      end
    end

    context 'when white king is castling' do
      xit 'can castle to queen side' do
        # Set king
        king = King.new(:white)

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[7][4] = king
        board[7][0] = Rook.new(:white)

        # Set origin and destination
        origin = [7,4]
        destination = [7,4]
        
        # This should return true, since it's a valid move
        expect(king.valid_move?(board, origin, destination)).to be true
      end

      xit 'can castle to queen side 2' do 
        # Set king
        king = King.new(:white)

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[7][4] = king
        board[7][0] = Rook.new(:white)

        # Set origin and destination
        origin = [7,4]
        destination = [7,4]
        
        # This should return true, since it's a valid move
        expect(king.valid_move?(board, origin, destination)).to be true
      end

      xit 'can castle to king side' do 
        # Set king
        king = King.new(:white)

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[7][4] = king
        board[7][7] = Rook.new(:white)

        # Set origin and destination
        origin = [7,4]
        destination = [7,6]
        
        # This should return true, since it's a valid move
        expect(king.valid_move?(board, origin, destination)).to be true
      end
    end
  end
end
