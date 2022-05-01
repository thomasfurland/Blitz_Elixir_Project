defmodule BlitzElixirProjectTest do
  use ExUnit.Case, async: true

  alias BlitzElixirProject.Fixtures

  setup do
    valid_summoner = Fixtures.valid_summoner()
    {:ok, agent} = Fixtures.test_agent()
    {:ok, supervisor} = Fixtures.test_supervisor()
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
