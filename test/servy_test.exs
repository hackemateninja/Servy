defmodule ServyTest do
  use ExUnit.Case, async: true
  doctest Servy

  test "greets the world" do
    assert Servy.hello() == :world
  end
end
