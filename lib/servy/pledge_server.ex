defmodule Servy.PledgeServer do
  @name_process :pledge_server

  use GenServer

  defmodule State do
    defstruct cache_size: 3, pledges: []
  end

  def start do
    GenServer.start(__MODULE__, %State{}, name: @name_process)
  end

  def create_pledge(name, amount) do
    GenServer.call(@name_process, {:create_pledge, name, amount})
  end

  def recent_pledges() do
    GenServer.call(@name_process, :recent_pledges)
  end

  def total_pledged() do
    GenServer.call(@name_process, :total_pledged)
  end

  def clear, do: GenServer.cast(@name_process, :clear)

  def set_cache_size(size) do
    GenServer.cast(@name_process, {:set_cache_size, size})
  end

  def init(%State{} = state) do
    pledges = fetch_recent_pledges_from_service()

    new_state = %{state | pledges: pledges}

    {:ok, new_state}
  end

  def handle_call(:total_pledged, _from, %State{} = state) do
    total = Enum.map(state.pledges, &elem(&1, 1)) |> Enum.sum()
    {:reply, total, state}
  end

  def handle_call(:recent_pledges, _from, %State{} = state) do
    {:reply, state.pledges, state}
  end

  def handle_call({:create_pledge, name, amount}, _from, %State{} = state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent = Enum.take(state.pledges, state.cache_size - 1)
    cached_pledges = [{name, amount} | most_recent]
    new_state = %{state | pledges: cached_pledges}
    {:reply, id, new_state}
  end

  def handle_cast(:clear, %State{} = state), do: {:noreply, %{state | pledges: []}}

  def handle_cast({:set_cache_size, size}, %State{} = state) do
    new_state = %{state | cache_size: size}
    {:noreply, new_state}
  end

  def handle_info(message, %State{} = state) do
    IO.puts("Can't touch this! #{inspect(message)}")
    {:noreply, state}
  end

  defp send_pledge_to_service(_name, _amout) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  defp fetch_recent_pledges_from_service do
    [{"wilma", 15}, {"fred", 25}]
  end
end

alias Servy.PledgeServer

{:ok, pid} = PledgeServer.start()

send(pid, {:stop, "hammertime"})

IO.inspect(PledgeServer.create_pledge("larry", 10))
IO.inspect(PledgeServer.create_pledge("moe", 20))
IO.inspect(PledgeServer.create_pledge("curly", 30))

IO.inspect(PledgeServer.clear())

IO.inspect(PledgeServer.create_pledge("daisy", 40))
IO.inspect(PledgeServer.create_pledge("grace", 50))

IO.inspect(PledgeServer.recent_pledges())

IO.inspect(PledgeServer.total_pledged())
