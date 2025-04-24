require 'colorize'

class Display
  def initialize(game_state)
    @game_state = game_state
  end

  def show_current_state
    puts "\nSecret Word: #{colorize_secret(@game_state.display_secret)}"
    unless @game_state.incorrect_letters.empty?
      puts "Incorrect Guesses: #{@game_state.incorrect_letters.join(', ').colorize(:red)}"
    end
    puts "Remaining Guesses: #{@game_state.remaining_guesses.to_s.colorize(:light_blue)}"
  end

  def show_game_over
    if @game_state.won?
      puts '🎉 Congratulations! You won! 🎉'.colorize(:green).bold
    else
      puts "☠️ Game Over! You Lost. The word was: #{@game_state.secret.colorize(:yellow)}".colorize(:red).bold
    end
  end

  def show_menu
    puts <<~MENU.colorize(:cyan).bold

      === Welcome to Hangman! ===
      1. New Game
      2. Load Game
      Choose an option:
    MENU
  end

  def show_save_prompt
    print '💾 Enter a filename to save as: '.colorize(:light_green)
  end

  def show_load_prompt
    print '📂 Enter the filename to load: '.colorize(:light_blue)
  end

  def show_save_success(filename)
    puts "✅ Game saved successfully as #{filename}".colorize(:green)
  end

  def show_load_error
    puts '❌ Error loading saved game!'.colorize(:red).bold
  end

  def show_guess_prompt
    print "🔤 Enter a letter to guess (or 'save' to save the game): ".colorize(:light_yellow)
  end

  def show_invalid_input
    puts '⚠️  Please enter a single letter from a-z.'.colorize(:yellow)
  end

  def show_duplicate_guess
    puts '🔁 You already guessed that letter.'.colorize(:magenta)
  end

  def colorize_secret(secret)
    secret.split.map do |char|
      char == '_' ? char.colorize(:light_black) : char.colorize(:white)
    end.join(' ')
  end
end
