# Class creation for mastermind game
class MastermingGame

  # Initialize with variable turn limits, colors and code length for quick
  # customization according to wants.
  def initialize(turn_limit, colors, code_length)
    @turn_limit = turn_limit
    @colors = colors
    @code_length = code_length

    # randomization of the secret code
    @secret_code = code_length.times.map {colors.sample}
    @secret_code_shielded = Array.new(code_length, '______')
  end

  # Function containing the main game loop
  def play
    iteration = 0

    # Main game loop
    while iteration < @turn_limit

      # Player's choice acquisition
      proposed_code = player_choice_acquisition()

      # Check if proposed match the secret code, it is the win condition
      if proposed_code == @secret_code
        puts 'YOU WIN!'
        break
      end

      # Update the shielded secret code 
      check_proposed_code(proposed_code)
      iteration += 1
    end
    puts 'GAME OVER' if iteration == @turn_limit
  end

  # Data acquisition from player, returns the proposed code as an array 
  # of strings
  def player_choice_acquisition
    (1..4).map do |choice|
      puts "indicate choice N°#{choice}:"
      gets.chomp
    end
  end

  # Compare proposed code and solution and update the shielded code
  def check_proposed_code(proposed_code)
    proposed_code.each_with_index do |value, index|
      @secret_code_shielded[index] = value if value == @secret_code[index]
    end
    puts "Code already discovered is: #{@secret_code_shielded.join(' ')}"
  end
end

# game initialization and start
color_list = %w[red blue orange yellow green purple]
new_game = MastermingGame.new(12, color_list, 4)
new_game.play
