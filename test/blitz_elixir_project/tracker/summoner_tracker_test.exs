defmodule BlitzElixirProject.Tracker.SummonerTrackerTest do
  use ExUnit.Case, async: true

  alias BlitzElixirProject.Tracker.{SummonerTracker, TrackingList}
  alias BlitzElixirProject.Fixtures

  setup do
    {:ok, agent} = TrackingList.start_link(%{}, name: :summoner_tracker_test)
    %{
      summoner: Fixtures.valid_summoner(),
      agent: agent
    }
  end

  describe "start_link/1" do
    test "success: creates summoner_tracker", context do
      assert {:ok, pid} = SummonerTracker.start_link(
        [
          summoner: context.summoner,
          pid: self(),
          agent: context.agent
        ])
      Process.sleep(50)
      assert Process.alive?(pid) === true
      assert %{} !== TrackingList.fetch_all(context.agent)

      assert_received :hello
    end
  end
end
