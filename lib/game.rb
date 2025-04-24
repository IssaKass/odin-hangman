require_relative 'dictionary'
require_relative 'display'
require_relative 'game_state'
require_relative 'save'

class Game
  def initialize
    @dictionary = Dictionary.new('words.txt')
    @display = Display.new(nil)
  end

  def start
    @display.show_menu
    option = gets.chomp

    @game_state = option == '2' ? load_game : new_game
    @display = Display.new(@game_state)

    play_round until @game_state.game_over?

    @display.show_current_state
    @display.show_game_over
  end

  private

  def new_game
    GameState.new(@dictionary.random_word)
  end

  def load_game
    @display.show_load_prompt
    filename = gets.chomp
    Save.load(filename) || new_game
  rescue StandardError
    @display.show_load_error
    new_game
  end

  def save_game
    @display.show_save_prompt
    filename = gets.chomp
    Save.save(@game_state, filename)
    @display.show_save_success(filename)
  end

  def play_round
    @display.show_current_state
    @display.show_guess_prompt
    input = gets.chomp.downcase

    return save_game if input == 'save'

    unless valid_letter?(input)
      @display.show_invalid_input
      return
    end

    if already_guessed?(input)
      @display.show_duplicate_guess
      return
    end

    @game_state.make_guess(input)
  end

  def valid_letter?(letter)
    letter.match?(/\A[a-z]\z/)
  end

  def already_guessed?(input)
    @game_state.correct_letters.include?(input) || @game_state.incorrect_letters.include?(input)
  end
end
