defmodule BlitzElixirProject.Tracker.NotifierTest do
  use ExUnit.Case, async: true

  alias BlitzElixirProject.Tracker.Notifier
  alias BlitzElixirProject.Fixtures

  setup do
    success_state = %{
      summoner: Fixtures.valid_summoner(),
      last_match_id: "0",
    }
    fail_state = %{
      summoner: Fixtures.valid_summoner(),
      last_match_id: "1",
    }
    %{success_state: success_state, fail_state: fail_state}
  end

  describe "update_match_status/1" do
    test "success: updates state", context do
      assert state = Notifier.update_match_status(context.success_state)
      assert state.summoner === context.success_state.summoner
      assert state.last_match_id !== context.success_state.last_match_id
    end

    test "failure: doesn't update state", context do
      assert state = Notifier.update_match_status(context.fail_state)
      assert state === context.fail_state
    end
  end

  describe "is_next_match?/2" do
    test "success: new match found and returns match_id", %{success_state: success} do
      assert {true, _} = Notifier.is_next_match?(success.summoner, success.last_match_id)
    end

    test "failure: no new match found", %{fail_state: fail_state} do
      assert false === Notifier.is_next_match?(fail_state.summoner, fail_state.last_match_id)
    end
  end
end
