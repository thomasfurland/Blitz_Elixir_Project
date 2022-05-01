defmodule BlitzElixirProjectTest do
  use ExUnit.Case, async: true

  alias BlitzElixirProject.{Fixtures, Tracker}

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
  describe "track_recent_opponents/3" do
    @tag :focus
    test "success: gets recently played summoners and starts trackers", %{name: name, region: region, opts: opts} do
      assert summoners = BlitzElixirProject.track_recent_opponents(name, region, opts)
      assert length(summoners) > 0

      assert_receive :hello
    end
    @tag :focus
    test "failure: uses non-existent name to get recently played summoners", %{region: region, opts: opts} do
      assert {:error, error} = BlitzElixirProject.track_recent_opponents("", region, opts)
      assert error.status_code === 9001
    end
  end
end
