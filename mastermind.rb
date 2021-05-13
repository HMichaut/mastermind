# Class creation for mastermind game
class MastermingGame

  # Initialize with variable turn limits, colors and code length for quick
  # customization according to wants.
  def initialize(turn_limit, colors, code_length)
    @turn_limit = turn_limit
    @colors = colors
    @code_length = code_length
    @player_role_selection = select_the_player_role
    @secret_code = create_secrete_code
  end

  # Define the player role based on input
  def select_the_player_role
    output = nil
    # input validation
    until %w[maker breaker].include?(output)
      puts 'Do you want to be a [maker] or a [breaker]?'
      output = gets.chomp
    end
    output
  end
  
  # Create the secret code according to the player role
  def create_secrete_code
    if @player_role_selection == 'breaker'
      output = computer_code_acquisition
    elsif @player_role_selection == 'maker'
      output = player_choice_acquisition
    end
    output
  end

  # Function containing the main game loop for computer breaker
  def play
    iteration = 0
    @proposed_code = []

    # Main game loop
    while iteration < @turn_limit

      # Computer and player hoice acquisition
      choice_acquisition

      # Check if proposed match the secret code, it is the win condition
      break if check_for_game_over

      # Check the code an puts the result
      acquire_check_proposed_code_result
      iteration += 1
    end
    puts 'GAME OVER' if iteration == @turn_limit
  end
  
  # Check for game over and returns boolean value accordingly
  def check_for_game_over
    if @proposed_code == @secret_code && @player_role_selection == 'breaker'
      puts 'YOU WIN!'
      true
    elsif @proposed_code == @secret_code && @player_role_selection == 'maker'
      puts 'COMPUTER WINS!'
      true
    else
      false
    end
  end

  # Acquisition of the proposed code according to player role
  def choice_acquisition
    if @player_role_selection == 'breaker'
      @proposed_code = player_choice_acquisition
    elsif @player_role_selection == 'maker'
      @proposed_code = computer_choice_acquisition
    end
    puts "Playing #{@proposed_code}"
  end

  # Data acquisition from player, returns the proposed code as an array
  # of strings, check for incorrect input
  def player_choice_acquisition
    puts "Choose between the following colors: #{@colors}"
    (1..@code_length).map do |choice|
      user_input = nil
      until @colors.include?(user_input)
        puts "indicate choice N°#{choice}:"
        user_input = gets.chomp
      end
      user_input
    end
  end

  # Randomization of computer choosen code
  def computer_code_acquisition
    @code_length.times.map { @colors.sample }
  end

  # Strategy of automatic code selection based on result
  def computer_choice_acquisition
    if @proposed_code == []
      @choice_list = @colors.repeated_permutation(@code_length).to_a
    else
      @choice_list.select! do |item|
        result_pair = check_proposed_code(item)
        result_pair[0] == @iteration_correct_value_and_position && result_pair[1] == @iteration_correct_value_wrong_position
      end
    end
    @choice_list[0]
  end

  # update the class values for check result and puts them
  def acquire_check_proposed_code_result
    result_pair = check_proposed_code(@secret_code)
    @iteration_correct_value_and_position = result_pair[0]
    @iteration_correct_value_wrong_position = result_pair[1]
    puts "Number of correct colors with correct position is: #{@iteration_correct_value_and_position}"
    puts "Number of correct colors with wrong position is: #{@iteration_correct_value_wrong_position}"
  end

  # Compare proposed code and solution puts the result on the pair form
  def check_proposed_code(secret_code_input)
    @secret_process_code = secret_code_input.dup
    @proposed_process_code = @proposed_code.dup
    correct_value_and_position = check_for_correct_value_and_position(secret_code_input)
    correct_value_wrong_position = check_for_correct_value_wrong_position
    [correct_value_and_position, correct_value_wrong_position]
  end

  # Compare proposed code and solution and return the number of correct value and position
  def check_for_correct_value_and_position(secret_code_input)
    index_correction = 0
    correct_value_and_position = 0
    @proposed_code.each_with_index do |value, index|
      if value == secret_code_input[index]
        @proposed_process_code.delete_at(index - index_correction)
        @secret_process_code.delete_at(index)
        correct_value_and_position += 1
        index_correction += 2
      end
    end
    correct_value_and_position
  end

  # Compare proposed code and solution and return the number of correct value with wrong position
  def check_for_correct_value_wrong_position
    correct_value_wrong_position = 0
    @proposed_process_code.each do |value|
      if @secret_process_code.include?(value)
        @secret_process_code.delete_at(@secret_process_code.index(value) || @secret_process_code.length)
        correct_value_wrong_position += 1
      end
    end
    correct_value_wrong_position
  end
end

# game initialization and start
color_list = %w[red blue orange yellow green purple]
new_game = MastermingGame.new(12, color_list, 4)
new_game.play