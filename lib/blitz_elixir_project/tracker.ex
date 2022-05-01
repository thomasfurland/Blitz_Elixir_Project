defmodule BlitzElixirProject.Tracker do
  alias BlitzElixirProject.Riot.Summoner
  alias BlitzElixirProject.Tracker.{SummonerTracker, TrackingList}
  alias BlitzElixirProject.TrackerSupervisor

  @spec spawn_summoner_trackers([Summoner.t], keyword) :: {:ok, integer}
  def spawn_summoner_trackers(summoners, opts \\ []) do
    success_count =
      summoners
      |> Task.async_stream(&(spawn_summoner_tracker(&1, opts)), ordered: false)
      |> Enum.reduce(0, &count_successful_starts/2)

    {:ok, success_count}
  end

  @spec spawn_summoner_tracker(Summoner.t(), keyword) ::
          :ignore | {:error, any} | {:ok, pid} | {:ok, pid, any}
  def spawn_summoner_tracker(summoner, opts \\ []) do
    supervisor = opts[:supervisor] || TrackerSupervisor
    agent = opts[:agent] || TrackingList
    args = Keyword.put(opts, :summoner, summoner)

    case TrackingList.lookup(agent, summoner) do
      nil ->
        start_tracker(supervisor, args)
      pid ->
        SummonerTracker.extend(pid)
        {:ok, pid}
    end
  end

  defp start_tracker(supervisor, args) do
    DynamicSupervisor.start_child(supervisor, {SummonerTracker, args})
  end

  defp count_successful_starts({:ok, _}, count), do: count + 1
  defp count_successful_starts({:error, _}, count), do: count
end
