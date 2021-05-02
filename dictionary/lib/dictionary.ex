defmodule Dictionary do
  def word_list do
    c = File.read!("assets/words.txt")
    list = String.split(c)
  end

  def random_word do
    Enum.random(word_list())
  end
end
