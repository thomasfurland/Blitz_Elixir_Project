defmodule BlitzElixirProject.Riot.SummonerTest do
  use ExUnit.Case, async: true

  alias BlitzElixirProject.Riot.Summoner

  setup do
    %{
      summoner_map: %{
        "region" => "euw1",
        "name" => "name",
        "puuid" => "puuid"
      }
    }
  end

  describe "from_map/1" do
    test "success: gets struct from map", context do
      assert %Summoner{} = summoner = Summoner.from_map(context.summoner_map)
      assert summoner.region === Map.get(context.summoner_map, "region")
      assert summoner.name === Map.get(context.summoner_map, "name")
      assert summoner.puuid === Map.get(context.summoner_map, "puuid")
    end
  end

end
