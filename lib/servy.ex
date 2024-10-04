defmodule Servy do
  @moduledoc """
  Documentation for `Servy`.
  """

  @list Enum.to_list(0..1)

  @doc """
  Hello world.

  ## Examples

      iex> Servy.hello()
      :world

  """

  def hello do
    :world
  end

  def hello(name) do
    "hello #{name}"
  end

  def my_map([head | tail], fun) do
    [fun.(head) | my_map(tail, fun)]
  end

  def my_map([], _fun), do: []

  def deck_cards do
    ranks =
      ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

    suits =
      ["♣", "♦", "♥", "♠"]

    deck = for rank <- ranks, suit <- suits, do: {rank, suit}

    deck
    |> Enum.shuffle()
    |> Enum.chunk_every(13)
    |> IO.inspect()
  end

  def loopy([head | tail]) do
    IO.puts("Head: #{head * 10 / 200} Tail: #{inspect(tail, charlists: :as_lists)}")
    loopy(tail)
  end

  def loopy([]), do: IO.puts("Done!")

  def sum([head | tail], total) do
    sum(tail, total + head)
  end

  def sum([], total), do: total

  def triple([head | tail]) do
    [head * 3 | triple(tail)]
  end

  def triple([]), do: []

  def other_triple(list) do
    o_triple(list, [])
  end

  defp o_triple([head | tail], current_list) do
    o_triple(tail, [head * 3 | current_list])
  end

  defp o_triple([], current_list) do
    current_list |> Enum.reverse()
  end

  def process_sublist(sublist), do: loopy(sublist)

  def process_task(list) do
    list
    |> Task.async_stream(&process_sublist/1, max_concurrency: System.schedulers_online())
    |> Enum.to_list()
  end

  def process_in_parallel(list) do
    cores = System.schedulers_online()
    sublists = Enum.chunk_every(list, div(length(list), cores))

    tasks = Enum.map(sublists, fn sublist -> Task.async(fn -> process_sublist(sublist) end) end)

    Enum.each(tasks, &Task.await/1)
  end

  def measure_loopy_execution do
    # Tiempo de ejecucion 13653495 microsegundos, 13.653495 segundos

    {time, _result} = :timer.tc(Servy, :loopy, [@list])

    IO.puts("Tiempo de ejecucion #{time}")
  end

  def measure_parallel_execution do
    {time, _result} = :timer.tc(fn -> process_in_parallel(@list) end)

    IO.puts("Tiempo de ejecucion #{time}")
  end

  def measure_task_execution do
    {time, _result} = :timer.tc(fn -> process_task(@list) end)
    IO.puts("Tiempo de ejecucion #{time}")
  end

  def measure_sum do
    {time, _result} = :timer.tc(fn -> sum(Enum.to_list(0..90_000_000), 0) end)
    IO.puts("Tiempo de ejecucion #{time / 1_000_000}")
  end

  def measure_triple do
    {time, _result} = :timer.tc(fn -> triple(Enum.to_list(0..90_000_000)) end)
    IO.puts("Tiempo de ejecucion #{time / 1_000_000}")
  end

  def measure_other_triple do
    {time, _result} = :timer.tc(fn -> other_triple(Enum.to_list(0..90_000_000)) end)
    IO.puts("Tiempo de ejecucion #{time / 1_000_000}")
  end
end

# 23181633/1000000 = 23.181633
# 2406856/1000000 = 2.406856
# 2026976/1000000 = 2.026976
IO.puts(Servy.hello())
IO.puts(Servy.hello("herman"))
