defmodule Hangman.Impl.Game do
  alias Hangman.Types

  @type t :: %__MODULE__{
          turns_left: integer(),
          state: Types.state(),
          letters: list(String.t()),
          used: MapSet.t(String.t())
        }

  defstruct(
    turns_left: 7,
    state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  @spec new_game() :: t
  def new_game do
    Dictionary.random_word()
    |> new_game
  end

  @spec new_game(String.t()) :: t
  def new_game(word) do
    # the following macro resolves to `Hangman.Impl.Game`
    %__MODULE__{
      letters: word |> String.codepoints()
    }
  end

  @spec make_move(t, String.t()) :: {t, Types.tally()}
  def make_move(game = %{state: state}, _guess) when state in [:won, :lost] do
    game
    |> return_with_tally()
  end

  def make_move(game, guess) do
    accept_guess(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally()
  end

  defp accept_guess(game, _guess, _already_used = true) do
    %{game | state: :already_used}
  end

  defp accept_guess(game, guess, _already_used = false) do
    %{game | used: MapSet.put(game.used, guess)}
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp score_guess(game, _good_guess = true) do
    # did we win?
    new_state = maybe_won(MapSet.subset?(MapSet.new(game.letters), game.used))
    %{game | state: new_state}
  end

  defp score_guess(game = %{turns_left: 1}, _good_guess = false) do
    %{game | state: :lost, turns_left: 0}
  end

  defp score_guess(game, _good_guess = false) do
    %{game | state: :bad_guess, turns_left: game.turns_left - 1}
  end

  defp maybe_won(true), do: :won
  defp maybe_won(_), do: :good_guess

  defp return_with_tally(game) do
    {game, tally(game)}
  end

  defp tally(game) do
    %{
      turns_left: game.turns_left,
      state: game.state,
      letters: reveal_guessed_letters(game),
      used: game.used |> MapSet.to_list() |> Enum.sort()
    }
  end

  defp reveal_guessed_letters(game) do
    game.letters
    |> Enum.map(fn letter -> MapSet.member?(game.used, letter) |> maybe_reveal(letter) end)
  end

  defp maybe_reveal(true, letter), do: letter
  defp maybe_reveal(_, _), do: "_"
end
