defmodule BlitzElixirProjectTest do
  use ExUnit.Case

  alias BlitzElixirProject.{Fixtures, Riot.Summoner, Tracker}

  setup do
    valid_summoner = Fixtures.valid_summoner()
    {:ok, agent} = Tracker.TrackingList.start_link(%{}, name: :main_tracker_test)
    {:ok, supervisor} = DynamicSupervisor.start_link(strategy: :one_for_one, name: :main_tracker_sup_test)
    %{
      name: valid_summoner.name,
      region: valid_summoner.region,
      opts: [matches: 20, pid: self(), agent: agent, supervisor: supervisor]
    }
  end
  describe "get_and_track_recently_played_summoners/3" do
    test "success: gets recently played summoners and starts trackers", %{name: name, region: region, opts: opts} do
      assert summoners = BlitzElixirProject.get_and_track_recently_played_summoners(name, region, opts)
      assert length(summoners) > 0
      for %Summoner{} = summoner <- summoners do
        assert summoner.region === region
      end
      assert_received :hello
    end

    test "failure: uses non-existent name to get recently played summoners", %{region: region, opts: opts} do
      assert {:error, error} = BlitzElixirProject.get_and_track_recently_played_summoners("", region, opts)
      assert error.status_code === 9001
    end
  end
end
