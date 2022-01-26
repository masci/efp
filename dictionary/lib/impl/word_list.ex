defmodule Dictionary.Impl.WordList do
  @type t :: list(String.t())

  @spec start :: t()
  def start do
    "assets/words.txt"
    |> File.read!()
    |> String.split(~r"\n", trim: true)
  end

  @spec random_word(t()) :: String.t()
  def random_word(words) do
    words
    |> Enum.random()
  end
end
