require 'spec_helper'
require_relative '../lib/chess.rb'
require_relative '../lib/chess_pieces.rb'
require_relative '../lib/utilities.rb'

RSpec.describe 'Load and Save' do

  include ChessUtilities

  describe '#parse_game_history_into_savegame_string' do
    context 'When parsing history to string,' do
      it 'From game with finished turns' do
        
        history_array = [["d4", "d5"], ["f3", "Qd6"], ["Bh6", "Qxh6"], ["Qd3", "Qc1+"], ["Qd1", "Qxd1+"]]
        valid_save = "1. d4 d5 2. f3 Qd6 3. Bh6 Qxh6 4. Qd3 Qc1+ 5. Qd1 Qxd1+"
        
        expect(export_history_array_to_string(history_array)).to eq(valid_save)
      end

      it 'From game with unfinished turns' do

        history_array = [["d4", "d5"], ["f3", "Qd6"], ["Bh6", "Qxh6"], ["Qd3", nil]]
        valid_save = "1. d4 d5 2. f3 Qd6 3. Bh6 Qxh6 4. Qd3 *"

        expect(export_history_array_to_string(history_array)).to eq(valid_save)
      end

      it 'In case of new game, give *' do

        history_array = []
        valid_save = "*"

        expect(export_history_array_to_string(history_array)).to eq(valid_save)
      end
    end

    context 'When parsing string to history,' do
      it 'From game with finished turns' do
        
        input_save = "1. d4 d5 2. f3 Qd6 3. Bh6 Qxh6 4. Qd3 Qc1+ 5. Qd1 Qxd1+"
        output_history = [["d4", "d5"], ["f3", "Qd6"], ["Bh6", "Qxh6"], ["Qd3", "Qc1+"], ["Qd1", "Qxd1+"]]
        
        expect(import_history_string_to_array(input_save)).to eq(output_history)
      end

      it 'From game with unfinished turns' do

        input_save = "1. d4 d5 2. f3 Qd6 3. Bh6 Qxh6 4. Qd3 *"
        output_history = [["d4", "d5"], ["f3", "Qd6"], ["Bh6", "Qxh6"], ["Qd3", nil]]

        expect(import_history_string_to_array(input_save)).to eq(output_history)
      end

      it 'In case of new game, give *' do

        input_save = "*"
        output_history = []

        expect(import_history_string_to_array(input_save)).to eq(output_history)
      end
    end
  end

  describe '#import_game_metadata_to_hash' do
    context 'When saving the game, export PGN structure' do
      it 'Saves the 7 tag roster' do
        # The seven tag names of the STR are (in order):
        # Event (the name of the tournament or match event)
        # Site (the location of the event)
        # Date (the starting date of the game)
        # Round (the playing round ordinal of the game)
        # White (the player of the white pieces)
        # Black (the player of the black pieces)
        # Result (the result of the game)

      input_game_metadata = {
          event: "World Championship",
          site: "London",
          date: "2024.05.20",
          round: "5",
          white: "Magnus Carlsen",
          black: "Gary Gasparovich",
          result: "1-0"
      }

      valid_result = "[Event \"World Championship\"]\n[Site \"London\"]\n[Date \"2024.05.20\"]\n[Round \"5\"]\n[White \"Magnus Carlsen\"]\n[Black \"Gary Gasparovich\"]\n[Result \"1-0\"]\n"

      expect(export_game_metadata_to_string(input_game_metadata)).to eq(valid_result)
      end
    end

    context 'When loading the game, import PGN structure' do
      it 'Loads the 7 tag roster' do
        # The seven tag names of the STR are (in order):
        # Event (the name of the tournament or match event)
        # Site (the location of the event)
        # Date (the starting date of the game)
        # Round (the playing round ordinal of the game)
        # White (the player of the white pieces)
        # Black (the player of the black pieces)
        # Result (the result of the game)

      input_string = "[Event \"World Championship\"]\n[Site \"London\"]\n[Date \"2024.05.20\"]\n[Round \"5\"]\n[White \"Magnus Carlsen\"]\n[Black \"Gary Gasparovich\"]\n[Result \"1-0\"]\n"
      
      valid_game_metadata = {
          event: "World Championship",
          site: "London",
          date: "2024.05.20",
          round: "5",
          white: "Magnus Carlsen",
          black: "Gary Gasparovich",
          result: "1-0"
      }

      expect(import_game_metadata_to_hash(input_string)).to eq(valid_game_metadata)
      end
    end
  end

  
end
