defmodule HangmanTest do
  use ExUnit.Case

  test "new game returns a structure" do
    game = Hangman.Impl.Game.new_game()
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "new game returns correct word" do
    game = Hangman.Impl.Game.new_game("foo")
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ["f", "o", "o"]
  end
end
