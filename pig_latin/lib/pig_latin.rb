require "pig_latin/version"

module PigLatin

  def self.convert(word)
    word.downcase!
    find_y = false

    if self.match_aeiou(word)
      if word.length == 1
        word + "ay"
      else
        until find_y || !self.match_consonant(word)
          word << word.slice!(0)
          find_y = true if self.match_y(word)
        end
        word + "ay"
      end
    else
      word + "way"
    end
  end

  def self.match_y(word)
    word.match(/\A[y]/i) ? true : false
  end

  def self.match_aeiou(word)
    word.match(/\A[aeiou]/i) ? true : false
  end

end