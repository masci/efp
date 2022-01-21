defmodule Hangman.Impl.Game do
  @type t :: %__MODULE__{
          turns_left: integer(),
          game_state: Hangman.state(),
          letters: list(String.t()),
          used: MapSet.t(String.t())
        }

  defstruct(
    turns_left: 7,
    game_state: :initializing,
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
end
