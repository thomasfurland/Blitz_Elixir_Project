defmodule BlitzElixirProject.TrackerTest do
  use ExUnit.Case, async: true

  alias BlitzElixirProject.{Fixtures, Tracker}

  setup do

    summoner1 = Fixtures.valid_summoner()
    summoner2 = summoner1 |> Map.replace(:puuid, "100")
    {:ok, agent} = Tracker.TrackingList.start_link(%{}, name: :tracker_test)
    {:ok, supervisor} = DynamicSupervisor.start_link(strategy: :one_for_one, name: :tracker_sup_test)
    pid = self()

    %{
      summoner: summoner1,
      summoner_list: [summoner1, summoner2],
      agent: agent,
      supervisor: supervisor,
      opts: [pid: pid, agent: agent, supervisor: supervisor]
    }
  end

  describe "spawn_summoner_trackers/2" do
    test "success: spawns list of summoner trackers", context do
      assert {:ok, count} = Tracker.spawn_summoner_trackers(context.summoner_list, context.opts)
      assert count === length(context.summoner_list)

      assert %{active: 2} = DynamicSupervisor.count_children(context.supervisor)
      assert_receive :hello
      assert_receive :hello
    end
  end

  describe "spawn_summoner_tracker/2" do
    test "success: spawns summoner tracker", context do
      assert {:ok, _} = Tracker.spawn_summoner_tracker(context.summoner, context.opts)
      assert 1 === Tracker.TrackingList.fetch_all(context.agent) |> Map.keys() |> length

      assert %{active: 1} = DynamicSupervisor.count_children(context.supervisor)
      assert_receive :hello
    end

    test "success: overwrites same summoner tracker", context do
      assert {:ok, _} = Tracker.spawn_summoner_tracker(context.summoner, context.opts)
      assert_receive :hello

      assert {:ok, _} = Tracker.spawn_summoner_tracker(context.summoner, context.opts)
      assert_receive :hello

      Process.sleep(50)
      assert %{active: 1} = DynamicSupervisor.count_children(context.supervisor)
    end
  end
end
