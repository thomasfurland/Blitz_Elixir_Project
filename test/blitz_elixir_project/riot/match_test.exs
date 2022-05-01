defmodule BlitzElixirProject.Riot.MatchTest do
  use ExUnit.Case, async: true

  alias BlitzElixirProject.Riot.Match

  setup do
    %{
      match_map: %{
        "region" => "euw1",
        "metadata" =>
          %{
            "matchId" => 1,
            "participants" => ["1","2"]
          }
        }
    }
  end

  describe "from_map/1" do
    test "success: creates new struct from map", context do
      assert %Match{} = match = Match.from_map(context.match_map)
      assert match.region === Map.get(context.match_map, "region")
      assert match.match_id === Map.get(context.match_map, "metadata") |> Map.get("matchId")
      assert match.participants === Map.get(context.match_map, "metadata") |> Map.get("participants")
    end
  end

end
