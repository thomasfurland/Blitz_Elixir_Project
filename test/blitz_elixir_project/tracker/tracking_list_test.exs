defmodule BlitzElixirProject.Tracker.TrackingListTest do
  use ExUnit.Case, async: true

  alias BlitzElixirProject.Tracker.TrackingList
  alias BlitzElixirProject.Fixtures

  setup do
    {:ok, pid} = TrackingList.start_link(%{}, name: :test_agent)
    %{
      agent: pid,
      summoner: Fixtures.valid_summoner(),
      pid: self()
    }
  end

  test "success: put and lookup summoner", context do
    assert :ok = TrackingList.put(context.agent, context.summoner, context.pid)
    assert context.pid === TrackingList.lookup(context.agent, context.summoner)
  end

  test "success: put and delete summoner", context do
    assert :ok = TrackingList.put(context.agent, context.summoner, context.pid)
    assert :ok === TrackingList.delete(context.agent, context.summoner)
    assert %{} === TrackingList.fetch_all(context.agent)
  end

  test "failure: lookup non-existent summoner", context do
    assert nil === TrackingList.lookup(context.agent, context.summoner)
  end
end
