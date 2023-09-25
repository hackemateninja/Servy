defmodule Servy do
  @moduledoc """
  Documentation for `Servy`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Servy.hello()
      :world

  """
  def hello(name) do
    "Hello, #{name}!"
  end

  def hello() do
    "Hello, nobody"
  end
end

IO.puts(Servy.hello("Herman"))
