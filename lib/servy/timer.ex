defmodule Servy.Timer do
  def remind(message, time) do
    spawn(fn ->
      :timer.sleep(time * 10)
      IO.puts(message)
    end)
  end
end
