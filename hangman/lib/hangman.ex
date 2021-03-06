defmodule Hangman do
  @moduledoc """
  Public API for `Hangman`.
  """
  alias Hangman.Impl.Game
  alias Hangman.Types
  @opaque game :: Game.t()

  @spec new_game() :: game
  defdelegate new_game, to: Game

  @spec make_move(game, String.t()) :: {game, Types.tally()}
  defdelegate make_move(game, guess), to: Game

  @spec tally(game) :: Types.tally()
  defdelegate tally(game), to: Game
end
