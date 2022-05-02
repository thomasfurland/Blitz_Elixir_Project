defmodule BlitzElixirProject.Riot.HTTPTest do
  use ExUnit.Case, async: true

  @moduletag :external

  alias BlitzElixirProject.Riot.HTTP
  alias BlitzElixirProject.Fixtures

  setup do
    summoner = Fixtures.valid_summoner()
    %{
      name: summoner.name,
      puuid: summoner.puuid,
      region: summoner.region,
      match_id: "EUW1_5799111248"
    }
  end

  describe "summoners_by_name/2" do
    test "success: gets requested user", context do
      assert {:ok, summoner} = HTTP.summoners_by_name(context.name, context.region)
      assert summoner.name === context.name
    end

    test "failure: gets non-existent user", context do
      assert {:error, error} = HTTP.summoners_by_name("", context.region)
      assert error.status_code === 403
    end
  end

  describe "summoners_by_puuid/2" do
    test "success: gets requested user", context do
      assert {:ok, summoner} = HTTP.summoners_by_puuid(context.puuid, context.region)
      assert summoner.puuid === context.puuid
    end

    test "failure: gets non-existent user", context do
      assert {:error, error} = HTTP.summoners_by_puuid("", context.region)
      assert error.status_code === 403
    end
  end

  describe "matches_by_puuid/3" do
    test "success: gets list of matches", context do
      assert {:ok, matches} = HTTP.matches_by_puuid(context.puuid, 5, context.region)
      assert length(matches) > 0
    end

    test "failure: gets non-existent user list of matches", context do
      assert {:error, error} = HTTP.matches_by_puuid("",5, context.region)
      assert error.status_code === 403
    end
  end

  describe "matches/2" do
    test "success: gets match", context do
      assert {:ok, match} = HTTP.matches(context.match_id, context.region)
      assert match.match_id === context.match_id
    end

    test "failure: gets non-existent match", context do
      assert {:error, error} = HTTP.matches("", context.region)
      assert error.status_code === 403
    end
  end
end
