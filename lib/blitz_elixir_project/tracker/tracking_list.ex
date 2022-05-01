defmodule BlitzElixirProject.Tracker.TrackingList do
  use Agent

  alias BlitzElixirProject.Riot

  @spec start_link(map, keyword) :: {:error, any} | {:ok, pid}
  def start_link(initial_value, opts \\ []) do
    name = Keyword.get(opts, :name, __MODULE__)
    Agent.start_link(fn -> initial_value end, name: name)
  end

  @spec put(atom | pid, Riot.Summoner.t, pid) :: :ok
  def put(name \\ __MODULE__, summoner, pid) do
    Agent.update(name, &(Map.put(&1, summoner, pid)))
  end

  @spec delete(atom | pid , Riot.Summoner.t) :: :ok
  def delete(name \\ __MODULE__, summoner) do
    Agent.update(name, &(Map.delete(&1, summoner)))
  end

  @spec lookup(atom | pid, Riot.Summoner.t) :: pid | nil
  def lookup(name \\ __MODULE__, summoner) do
    Agent.get(name, &(Map.get(&1, summoner)))
  end

  @spec fetch_all(atom | pid) :: map
  def fetch_all(name \\ __MODULE__) do
    Agent.get(name, &(&1))
  end

end
