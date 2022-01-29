defmodule Dictionary do
  @moduledoc """
  Documentation for `Dictionary`.
  """
  alias Dictionary.Runtime.Server

  @opaque t :: Server.t()

  @spec random_word() :: String.t()
  defdelegate random_word(), to: Server
end
