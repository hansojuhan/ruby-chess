module ChessUtilities

  EXTENSION = ".pgn"
  SAVE_PATH = "saves"

  # Get a name and check it doesn't exist
  def find_valid_save_filename(path)
    name_valid = false
    until name_valid

      name = gets.chomp
      name = name << EXTENSION

      if File.exist?("#{SAVE_PATH}/#{name}")
        print "Save already exists, choose another name: "
      else
        return name
      end 
    end
  end

  # Writes the save into the file
  def save_game_to_file(filename)
    begin
      file = File.open("#{SAVE_PATH}/#{filename}", "w")

      # First, the 7 tags from the game_metadata
      game_metadata_string = export_game_metadata_to_string(game_metadata)
      # After that, the game string
      game_turns_string = parse_game_history_into_savegame_string(history)

      binding.pry
      file.write(game_metadata_string)
      file.write("\n")
      file.write(game_turns_string)

    rescue IOError => e
      # Errors? Haven't seen any so far.
    ensure
      file.close
    end
  end

  def save_game
    # To save game, need to 
    # 1) Get a savegame name
    # 2) Check in the folder if such file exists
    # 3) If folder does not exist, create that
    # 4) Then save file

    # First, check folder exists. If not, make it
    Dir.mkdir("saves") unless Dir.exist?(SAVE_PATH) 

    print "\nEnter a name for the save: "
    name = find_valid_save_filename(SAVE_PATH)
    
    # Open and write that into the file
    save_game_to_file(name)

    # Return
    puts "Game saved as '#{name}'. Press any key to return."
    gets
  end

  def load_game
    # List all savefiles in the saves directory
    list_all_saved_games

    # Select a save
    selected_save_file = get_saved_game_file_name

    # Read the savefile and retrieve the info into a hash
    # Returns a hash with 1) metadata, 2) history 
    save_file_contents = read_saved_game_file_into_hash(selected_save_file)

    # If no metadata, replace with default
    save_file_contents[:metadata] = initialize_metadata if save_file_contents[:metadata].nil? 
   
    # To "load" the game and update the gamestate
    # Go through the history, split into turns
    # For each turn go through the two moves
return
    # Each move, we need origin and destination
    # Destination is always in the text
    # Origin is represented by the piece (nothing if pawn)
    # Determine the piece by the symbol
    # For the piece, find the piece on the board -> origin
    # With origin, destination, call the make move
    # Iterate until done, right key forward, left back, enter to start game

    # TODO: if capturing with pawn, add the origin square column "bxc5"
    # TODO: moving with rook, add the origin square column
    # If there are 2 rooks and both can validly make a move

    # Call makemove on the coordinates with origin and destination

    # Update class variables
  end

  def initialize_metadata
    {
      event: "?",
      site: "?",
      date: "????.??.??",
      round: "?",
      white: "?",
      black: "?",
      result: "*"
    }
  end

  # Reads the contents of a pgn file into a hash
  def read_saved_game_file_into_hash(selected_save_file)

    contents = {}

    tags = ""
    turns = ""

    # Read same file
    begin
      # Open and read file
      file = File.open("#{SAVE_PATH}/#{selected_save_file}", "r")

      File.readlines(file, chomp: true).each do |line|

        if line.empty?
          next
        elsif line.match(/\[([A-Za-z]+) \"(.+?)\"\]/)
          tags << "#{line}\n"
        elsif line.match("\d+\.")
          turns << "#{line}"
        end

      end

    rescue IOError => e
      # Errors? Don't think so.
    ensure
      file.close
    end

    # If present, save the metadata using #import_game_metadata_to_hash
    contents[:metadata] = import_game_metadata_to_hash(tags)
    contents[:history] = import_history_string_to_array(turns)
binding.pry
    return contents
  end

  # Lists out all savefiles in the defined path with defined extension
  def list_all_saved_games
    puts "\nYour saved games:"
    Dir.foreach("#{SAVE_PATH}") do |savefile|
      puts savefile.chomp(EXTENSION) if savefile.include?(EXTENSION)
    end
  end

  def get_saved_game_file_name
    name_valid = false
    until name_valid

      name = gets.chomp
      name = name << EXTENSION

      if File.exist?("#{SAVE_PATH}/#{name}")
        return name
      else
        print `clear`
        print "Save does not exist"
        list_all_saved_games
      end 
    end
  end

  def update_game_state(data)
    # Open and write that into the file
    puts "TODO"
    gets
    # @remaining_guesses = data.remaining_guesses
    # @secret_word = data.secret_word
    # @guessed_word = data.guessed_word
    # @last_guess = data.last_guess
  end

  def export_history_array_to_string(input)
    
    # input = [["d4", "d5"], ["f3", "Qd6"], ["Bh6", "Qxh6"], ["Qd3", "Qc1+"], ["Qd1", "Qxd1+"]]
    # output = "1. d4 d5 2. f3 Qd6 3. Bh6  Qxh6 4. Qd3  Qc1+ 5. Qd1 Qxd1"
    
    # New game check
    return "*" if input.empty?

    # Construct a string
    output = ""
    
    # For each substring
    input.each_with_index do |turn, turn_index|
      # Append string
      output << "#{turn_index + 1}. "

      # For each move in the turn 
      turn.each do |move|
        unless move.nil?
          output << "#{move} "
        else
          output << "*"
        end
      end

    end

    # Remove trailing whitespace
    return output.strip
  end

  def import_history_string_to_array(input)
    # Return empty array for empty history
    return [] if input.empty? || input == "*"

    # Use this crazy regex that GPT created
    turns = input.scan(/\d+\.\s*([^\s]+)\s+([^\s]+)/)

    # Turn the '*' into nil, if exists
    turns[-1][-1] = nil if turns[-1][-1] == "*"

    # Remove trailing whitespace
    return turns
  end

  def export_game_metadata_to_string(game_metadata)
    return game_metadata.map { |key, value| "[#{key.to_s.capitalize} \"#{value}\"]" }.join("\n") + "\n"
  end

  def import_game_metadata_to_hash(input_game_metadata)

    metadata = {}

    # Split at newline
    tag_lines = input_game_metadata.split("\n")

    # Check each tag
    tag_lines.each do |tag|
      # And match the key and value using regex
      match = tag.match(/\[([A-Za-z]+) \"(.+?)\"\]/)

      # If match, save it
      if match
        key = match[1].downcase.to_sym
        value = match[2]
        metadata[key] = value
      end
    end
    
    return metadata
  end
end
