defmodule TextClient.Impl.Player do
  alias Hangman.Types

  @spec start() :: :ok
  def start() do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    interact({game, tally})
  end

  @spec interact({Hangman.game(), Types.tally()}) :: :ok
  def interact({_game, _tally = %{state: :won}}), do: IO.puts("Congratulations, you won!")

  def interact({_game, tally = %{state: :lost}}) do
    IO.puts("You lost! The word was #{tally.letters |> Enum.join()}")
  end

  def interact({game, tally}) do
    IO.puts(feedback_for(tally))
    IO.puts(current_word(tally))

    Hangman.make_move(game, get_guess())
    |> interact()
  end

  @spec feedback_for(Types.tally()) :: String.t()
  def feedback_for(tally = %{state: :initializing}) do
    "Welcome! I'm thinking of a #{tally.letters |> length} letter word"
  end

  def feedback_for(_tally = %{state: :good_guess}), do: "Good guess!"

  def feedback_for(_tally = %{state: :bad_guess}), do: "Sorry, letter not in word!"

  def feedback_for(_tally = %{state: :already_used}), do: "You already used that letter!"

  def current_word(tally) do
    [
      "word so far: ",
      tally.letters |> Enum.join(""),
      " turns left: ",
      tally.turns_left |> to_string(),
      " used so far: ",
      tally.used |> Enum.join(",")
    ]
  end

  def get_guess() do
    IO.gets("Letter: ")
    |> String.trim()
    |> String.downcase()
  end
end
