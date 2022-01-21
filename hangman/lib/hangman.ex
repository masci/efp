defmodule Hangman do
  @moduledoc """
  Documentation for `Hangman`.
  """
  alias Hangman.Impl.Game
  alias Hangman.Type
  @opaque game :: Game.t()

  @spec new_game() :: game
  defdelegate new_game, to: Game

  @spec make_move(game, String.t()) :: {game, Type.tally()}
  def make_move(_game, _guess) do
    {%{}, %{turns_left: 0, game_state: :won, letters: [], used: []}}
  end
end
