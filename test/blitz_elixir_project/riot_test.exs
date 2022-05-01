defmodule BlitzElixirProject.RiotTest do
  use ExUnit.Case, async: true

  alias BlitzElixirProject.{Riot, Fixtures}


  setup do
    valid_summoner = Fixtures.valid_summoner()
    invalid_summoner = valid_summoner |> Map.replace(:puuid, "")

    %{
      valid_summoner: valid_summoner,
      invalid_summoner: invalid_summoner,
      count: 2,
      id_list: ["1", "2"],
      bad_id_list: ["", "", ""],
      region: "euw1",
      summoners_ids: ["1","2","3","4","5"]
    }
  end

  describe "fetch_recently_played_summoners/2" do
    test "success: gets list of summoners", context do
      assert {:ok, summoners} = Riot.fetch_recently_played_summoners(context.valid_summoner, context.count)
      assert length(summoners) > 0
      assert Enum.member?(summoners, context.valid_summoner) === false
    end

    test "failure: uses non-existent user to get list of summoners", context do
      assert {:error, error} = Riot.fetch_recently_played_summoners(context.invalid_summoner, context.count)
      assert error.status_code === 9001
    end
  end

  describe "fetch_summoner_ids_from_matches/2" do
    test "success: gets list of unique summoner ids", context do
      assert {:ok, summoner_ids} = Riot.fetch_summoner_ids_from_matches(context.id_list, context.region)
      assert summoner_ids === context.summoners_ids
    end

    test "failure: uses non-existent matches to get summoner ids", context do
      assert {:error, errors} = Riot.fetch_summoner_ids_from_matches(context.bad_id_list, context.region)
      assert length(errors) === length(context.bad_id_list)
      for %{status_code: status_code} <- errors do
        assert status_code === 9001
      end
    end
  end

  describe "fetch_summoners_by_ids/2" do
    test "success: gets list of summoners with list of ids", context do
      assert {:ok, summoners} = Riot.fetch_summoners_by_ids(context.id_list, context.region)
      assert length(summoners) === length(context.id_list)
      for %Riot.Summoner{} = summoner <- summoners do
        assert summoner.region === context.region
      end
    end

    test "failure: uses non-existent users to get summoners", context do
      assert {:error, errors} = Riot.fetch_summoners_by_ids(context.bad_id_list, context.region)
      assert length(errors) === length(context.bad_id_list)
      for %{status_code: status_code} <- errors do
        assert status_code === 9001
      end
    end
  end
end
