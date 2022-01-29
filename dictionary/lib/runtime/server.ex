defmodule Dictionary.Runtime.Server do
  alias Dictionary.Impl.WordList

  @type t :: pid()

  @pid __MODULE__

  def start_link do
    Agent.start_link(&WordList.start/0, name: @pid)
  end

  def random_word() do
    Agent.get(@pid, &WordList.random_word/1)
  end
end
