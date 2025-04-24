require 'json'
require_relative 'game_state'

class Save
  SAVE_DIR = File.expand_path('../saves', __dir__)

  def self.save(game_status, filename)
    Dir.mkdir(SAVE_DIR) unless Dir.exist?(SAVE_DIR)

    filepath = File.join(SAVE_DIR, sanitize_filename(filename))

    data = {
      secret: game_status.secret,
      correct_letters: game_status.correct_letters,
      incorrect_letters: game_status.incorrect_letters,
      remaining_guesses: game_status.remaining_guesses
    }

    File.write(filepath, JSON.pretty_generate(data))
    true
  rescue StandardError => e
    warn "Failed to save game: #{e.message}"
    false
  end

  def self.load(filename)
    filepath = File.join(SAVE_DIR, sanitize_filename(filename))
    data = JSON.parse(File.read(filepath), symbolize_names: true)

    required_keys = %i[secret correct_letters incorrect_letters remaining_guesses]

    unless required_keys.all? { |key| data.key?(key) }
      warn 'Invalid save file format.'
      return nil
    end

    GameState.new(
      data[:secret],
      data[:correct_letters],
      data[:incorrect_letters],
      data[:remaining_guesses]
    )
  rescue StandardError
    warn "Failed to load game: #{e.message}"
  end

  def self.sanitize_filename(name)
    "#{name.gsub(/[^0-9A-Za-z.-]/, '_')}.json"
  end
end
