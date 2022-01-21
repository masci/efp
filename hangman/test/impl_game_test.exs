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

  test "letters in word are recognized" do
    game = Hangman.Impl.Game.new_game("foo")
    {_game, tally} = Hangman.Impl.Game.make_move(game, "f")
    assert tally.game_state == :good_guess
  end

  test "letters not in word are recognized" do
    game = Hangman.Impl.Game.new_game("foo")
    {_game, tally} = Hangman.Impl.Game.make_move(game, "b")
    assert tally.game_state == :bad_guess
  end

  test "winning game sequence" do
    [
      # guess | state | turns_left | letters | used
      ["a", :bad_guess, 6, ["_", "_", "_"], ["a"]],
      ["f", :good_guess, 6, ["f", "_", "_"], ["a", "f"]],
      ["x", :bad_guess, 5, ["f", "_", "_"], ["a", "f", "x"]],
      ["a", :already_used, 5, ["f", "_", "_"], ["a", "f", "x"]],
      ["o", :won, 5, ["f", "o", "o"], ["a", "f", "o", "x"]]
    ]
    |> test_game_sequence
  end

  test "losing game sequence" do
    [
      # guess | state | turns_left | letters | used
      ["a", :bad_guess, 6, ["_", "_", "_"], ["a"]],
      ["b", :bad_guess, 5, ["_", "_", "_"], ["a", "b"]],
      ["c", :bad_guess, 4, ["_", "_", "_"], ["a", "b", "c"]],
      ["d", :bad_guess, 3, ["_", "_", "_"], ["a", "b", "c", "d"]],
      ["e", :bad_guess, 2, ["_", "_", "_"], ["a", "b", "c", "d", "e"]],
      ["g", :bad_guess, 1, ["_", "_", "_"], ["a", "b", "c", "d", "e", "g"]],
      ["h", :lost, 0, ["_", "_", "_"], ["a", "b", "c", "d", "e", "g", "h"]]
    ]
    |> test_game_sequence
  end

  def test_game_sequence(input) do
    game = Hangman.Impl.Game.new_game("foo")
    Enum.reduce(input, game, &check_one_move/2)
  end

  def check_one_move([guess, state, turns, letters, used], g) do
    {game, tally} = Hangman.Impl.Game.make_move(g, guess)
    assert tally.game_state == state
    assert tally.turns_left == turns
    assert tally.letters == letters
    assert tally.used == used

    game
  end
end
