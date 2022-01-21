defmodule Dictionary do
  @moduledoc """
  Documentation for `Dictionary`.
  """

  # @word_list is a "module attribute" and is created
  # at compile time, this means we don't need to ship
  # the words file because it's loaded at compile time
  # already
  @word_list "assets/words.txt"
             |> File.read!()
             |> String.split(~r"\n", trim: true)

  def random_word do
    @word_list
    |> Enum.random()
  end
end
