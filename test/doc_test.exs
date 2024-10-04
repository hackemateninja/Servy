defmodule DocTest do
  use ExUnit.Case
  doctest Servy.Parser
  doctest Servy.Handler
  doctest Servy.Plugins
end
