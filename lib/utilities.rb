module ChessUtilities

  EXTENSION = ".chess"
  SAVE_PATH = "/saves"
  PERMITTED_CLASS = Chess

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

  # Files the class state to file as yaml
  def save_game_to_file(filename)
    begin
      file = File.open("#{SAVE_PATH}/#{filename}", "w")
      file.write(class_to_yaml)
    rescue IOError => e
      # Errors?
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
    # 5) Saving file is dumping the class into yaml

    # First, check folder exists. If not, make it
    Dir.mkdir("saves") unless Dir.exist?(SAVE_PATH) 

    print "\nEnter a name for the save: "
    name = find_valid_save_filename(SAVE_PATH)
    
    # Open and write that into the file
    save_game_to_file(name)

    # Go back to the beginning
    puts "Game saved as '#{name}'. Press any key to go to main menu."
    gets
  end

  def list_saved_games
    puts "\nYour saved games:"
    Dir.foreach("#{SAVE_PATH}") do |savefile|
      puts savefile.chomp(EXTENSION) if savefile.include?(EXTENSION)
    end
  end

  def select_saved_game
    name_valid = false
    until name_valid

      name = gets.chomp
      name = name << EXTENSION

      if File.exist?("#{SAVE_PATH}/#{name}")
        return name
      else
        print `clear`
        print "Save does not exist"
        list_saved_games
      end 
    end
  end

  def load_game
    # List all savefiles in the save directory
    list_saved_games

    # Select a save
    name = select_saved_game

    # Read same file
    begin
      file = File.open("#{SAVE_PATH}/#{name}", "r")
      lines = File.read(file)

      # Safe load the data, permetting the Hangman class only
      data = YAML.safe_load(lines, permitted_classes: [PERMITTED_CLASS])
    rescue IOError => e
      # Errors
    ensure
      file.close
    end

    # Update the instance variables to load the game
    self.update_game_state(data)
  end

  # Create the yaml dump of the class
  def class_to_yaml
    YAML.dump (self)
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


  # Takes current game history array
  # And outputs
  def create_save_file(input)
    
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

  def export_game_metadata_to_string(game_metadata)

    # game_metadata_string = ""

    # # Go through each key
    # game_metadata.each do |key, value|
    #   # And build part of the string
    #   game_metadata_string << "[#{key.to_s.capitalize} \"#{value}\"]\n"
    # end

    # game_metadata_string = game_metadata.map { |key, value| "[#{key.to_s.capitalize} \"#{value}\"]" }.join("\n") + "\n"

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
