defmodule BlitzElixirProject.Tracker.SummonerTracker do
  use GenServer, restart: :temporary

  alias BlitzElixirProject.Config
  alias BlitzElixirProject.Tracker.TrackingList

  def init(args) do
    state = %{
      summoner: args[:summoner],
      last_match_id: "",
      agent: args[:agent] || TrackingList,
      pid: args[:pid] #for testing... used to send message back to test process
    }
    {:ok, state, {:continue, :start_loop}}
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def delete(pid) do
    GenServer.cast(pid, :shutdown)
  end

  def handle_cast(:shutdown, state), do: {:stop, :normal, state}

  def handle_continue(:start_loop, %{summoner: summoner, agent: agent} = state) do
    TrackingList.put(agent, summoner, self())
    Process.send(self(), :check_status, [])
    Process.send_after(self(), :expire, Config.tracker_expiry())
    {:noreply, state}
  end

  def handle_info(:check_status, state) do
    new_state = apply(Config.notifier(), :notify, [state])
    Process.send_after(self(), :check_status, Config.tracker_interval())
    {:noreply, new_state}
  end

  def handle_info(:expire, state), do: {:stop, :normal, state}

  def terminate(_reason, %{summoner: summoner, agent: agent}), do: TrackingList.delete(agent, summoner)
end
