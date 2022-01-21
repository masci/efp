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

  test "state not changing if game won or lost" do
    for state <- [:won, :lost] do
      game = Hangman.Impl.Game.new_game("foo")
      game = Map.put(game, :game_state, state)
      {new_game, _tally} = Hangman.Impl.Game.make_move(game, "a")
      assert new_game == game
    end
  end

  test "a duplicate letter is reported" do
    game = Hangman.Impl.Game.new_game("foo")
    {game, _tally} = Hangman.Impl.Game.make_move(game, "a")
    assert game.game_state != :already_used
    {game, _tally} = Hangman.Impl.Game.make_move(game, "b")
    assert game.game_state != :already_used
    {game, _tally} = Hangman.Impl.Game.make_move(game, "a")
    assert game.game_state == :already_used
  end

  test "letters used are recorded" do
    game = Hangman.Impl.Game.new_game("foo")
    {game, _tally} = Hangman.Impl.Game.make_move(game, "a")
    {game, _tally} = Hangman.Impl.Game.make_move(game, "b")
    {game, _tally} = Hangman.Impl.Game.make_move(game, "a")
    assert MapSet.equal?(game.used, MapSet.new(["a", "b"]))
  end
end
