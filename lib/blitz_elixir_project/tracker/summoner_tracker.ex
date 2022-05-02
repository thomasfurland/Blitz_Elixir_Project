defmodule BlitzElixirProject.Tracker.SummonerTracker do
  use GenServer, restart: :temporary

  alias BlitzElixirProject.Config
  alias BlitzElixirProject.Tracker.TrackingList

  def init(args) do
    state = %{
      summoner: args[:summoner],
      last_match_id: "",
      expiry: refresh_expiry(),
      agent: args[:agent] || TrackingList,
      pid: args[:pid] #for testing... used to send message back to test process
    }
    {:ok, state, {:continue, :start_loop}}
  end

  @spec start_link(keyword) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  @spec extend(atom | pid) :: :ok
  def extend(pid) do
    GenServer.cast(pid, :extend)
  end

  def handle_cast(:extend, state) do
    new_state = Map.replace(state, :expiry, refresh_expiry())
    {:noreply, new_state}
  end

  def handle_continue(:start_loop, %{summoner: summoner, agent: agent} = state) do
    TrackingList.put(agent, summoner, self())
    Process.send(self(), :check_status, [])
    Process.send_after(self(), :check_expired, Config.tracker_interval())
    {:noreply, state}
  end

  def handle_info(:check_status, state) do
    new_state = apply(Config.notifier(), :notify, [state])
    Process.send_after(self(), :check_status, Config.tracker_interval())
    {:noreply, new_state}
  end

  def handle_info(:check_expired, %{expiry: expiry} = state) do
    if is_expired?(expiry) do
      {:stop, :normal, state}
    else
      Process.send_after(self(), :check_expired, Config.tracker_interval())
      {:noreply, state}
    end
  end

  def terminate(_reason, %{summoner: summoner, agent: agent}), do: TrackingList.delete(agent, summoner)

  defp refresh_expiry, do: DateTime.add(DateTime.now!("Etc/UTC"), Config.tracker_expiry, :millisecond)
  defp is_expired?(expiry) do
    case DateTime.compare(DateTime.now!("Etc/UTC"), expiry) do
      :gt -> true
      _ -> false
    end
  end
end
