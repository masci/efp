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
    # the following macro resolves to `Hangman.Impl.Game`
    %__MODULE__{
      letters: Dictionary.random_word() |> String.codepoints()
    }
  end
end
