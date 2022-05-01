defmodule BlitzElixirProject.Fixtures do

  alias BlitzElixirProject.{Riot, Tracker}

  def valid_summoner() do
    %Riot.Summoner{
      name: "Babus",
      puuid: "x4GP5BPWiOyM11HVkVa1HQsr8bzW-SqGxKvoA-GGh3_x-I9dwJ4iy-OjPe6zcAEsaciPn-I4R9poAA",
      region: "euw1",
    }
  end

  def test_agent do
    Tracker.TrackingList.start_link(%{}, name: {
      :via, Registry, {BlitzElixirProject.Registry, {:agent, self()}}
    })
  end
  def test_supervisor do
    DynamicSupervisor.start_link(strategy: :one_for_one, name: {
      :via, Registry, {BlitzElixirProject.Registry, {:sup, self()}}
    })
  end
end
