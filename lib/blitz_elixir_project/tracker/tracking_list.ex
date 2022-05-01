defmodule BlitzElixirProject.Tracker.TrackingList do
  use Agent

  def start_link(initial_value, opts \\ []) do
    name = Keyword.get(opts, :name, __MODULE__)
    Agent.start_link(fn -> initial_value end, name: name)
  end

  def put(name \\ __MODULE__, summoner, pid) do
    Agent.update(name, &(Map.put(&1, summoner, pid)))
  end

  def delete(name \\ __MODULE__, summoner) do
    Agent.update(name, &(Map.delete(&1, summoner)))
  end

  def lookup(name \\ __MODULE__, summoner) do
    Agent.get(name, &(Map.get(&1, summoner)))
  end

  def fetch_all(name \\ __MODULE__) do
    Agent.get(name, &(&1))
  end

end
