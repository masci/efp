defmodule Hangman.Types do
  @type state :: :initializing | :won | :lost | :good_guess | :bad_guess | :already_used
  @type tally :: %{
          turns_left: integer,
          state: state,
          letters: list(String.t()),
          used: list(String.t())
        }
end
