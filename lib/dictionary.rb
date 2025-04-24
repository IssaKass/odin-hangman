class Dictionary
  attr_reader :words

  def initialize(file_path, min_length = 5, max_length = 12)
    full_path = File.expand_path(file_path, __dir__)
    raise "Dictionary file not found: #{full_path}" unless File.exist?(full_path)

    @words = load_words(full_path, min_length, max_length)
  end

  def random_word
    words.sample.downcase
  end

  private

  def load_words(path, min_length, max_length)
    File.readlines(path, chomp: true)
        .select { |word| word.size.between?(min_length, max_length) }
  end
end
