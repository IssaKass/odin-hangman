class GameState
  MAX_GUESSES = 6

  attr_reader :secret, :correct_letters, :incorrect_letters, :remaining_guesses

  def initialize(secret, correct_letters = [], incorrect_letters = [], remaining_guesses = MAX_GUESSES)
    @secret = secret
    @correct_letters = correct_letters
    @incorrect_letters = incorrect_letters
    @remaining_guesses = remaining_guesses
  end

  def game_over?
    won? || lost?
  end

  def won?
    (@secret.chars.uniq - @correct_letters).empty?
  end

  def lost?
    @remaining_guesses <= 0
  end

  def display_secret
    @secret.chars
           .map { |char| @correct_letters.include?(char) ? char : '_' }
           .join(' ')
  end

  def make_guess(letter)
    letter = letter.downcase
    return if guessed?(letter)

    if @secret.include?(letter)
      @correct_letters << letter
    else
      @incorrect_letters << letter
      @remaining_guesses -= 1
    end
  end

  def guessed?(letter)
    @correct_letters.include?(letter) || incorrect_letters.include?(letter)
  end
end
