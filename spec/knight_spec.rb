require 'spec_helper'
require_relative '../lib/chess.rb'
require_relative '../lib/chess_pieces.rb'

RSpec.describe '.Knight' do
  describe '#valid_move?' do

    # Knight has 8 potential destinations
    # If origin is 4,4, these are, clockwise
    # 1)  2,5
    # 2)  3,6
    # 3)  5,6
    # 4)  6,5
    # 5)  6,3
    # 6)  5,2
    # 7)  3,2
    # 8)  2,3

    context 'when moving to a destination' do
      it 'return true, when moving to a valid destination' do
        # Set knight
        knight = Knight.new
  
        # Set board
        board = Array.new(8) { Array.new(8) }
        board[4][4] = knight
  
        # Set origin and destination
        origin = [4,4]
        destinations = [[2,5],[3,6],[5,6],[6,5],[6,3],[5,2],[3,2],[2,3]]
        
        destinations.each do |destination|
          # This should return true, since it's a valid move
          expect(knight.valid_move?(board, origin, destination)).to be true
        end
      end

      it 'returns false, when moving to a nonvalid destination' do
        # Set knight
        knight = Knight.new
  
        # Set board
        board = Array.new(8) { Array.new(8) }
        board[4][4] = knight
  
        # Set origin and destination
        origin = [4,4]
        destinations = [[0,0],[0,1],[7,7],[100,10],[-1,-8],[5,5],[6,4],[3,7]]
        
        destinations.each do |destination|
          # This should return true, since it's a valid move
          expect(knight.valid_move?(board, origin, destination)).to be false
        end
      end
      
    end

    context 'when destination contains' do
      it 'opponent piece, returns true' do
        # Set knight
        knight = Knight.new(:white)

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[4][4] = knight
  
        board[2][5] = Knight.new(:black)

        # Set origin and destination
        origin = [4,4]
        destination = [2,5]
        
        # This should return true, since it's a valid move
        expect(knight.valid_move?(board, origin, destination)).to be true
      end

      it 'own piece, returns false' do
        # Set knight
        knight = Knight.new(:white)

        # Set board
        board = Array.new(8) { Array.new(8) }
        board[4][4] = knight
  
        board[2][5] = Knight.new(:white)

        # Set origin and destination
        origin = [4,4]
        destination = [2,5]
        
        # This should return true, since it's a valid move
        expect(knight.valid_move?(board, origin, destination)).to be false
      end
    end
  end
end
