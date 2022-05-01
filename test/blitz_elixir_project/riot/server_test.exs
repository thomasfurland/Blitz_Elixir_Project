defmodule BlitzElixirProject.Riot.ServerTest do
  use ExUnit.Case, async: true

  alias BlitzElixirProject.Riot.Server

  setup do
    %{
      region: "euw1",
      region_uri: "https://euw1.api.riotgames.com/",
      continent_uri: "https://europe.api.riotgames.com/",
      bad_region: ""
    }
  end

  describe "from_region/1" do
    test "success: gets correct server", context do
      assert {:ok, %Server{} = server} = Server.from_region(context.region)
      assert server.region_uri === context.region_uri
      assert server.continent_uri === context.continent_uri
    end

    test "failure: fetch incorrect server", context do
      assert {:error, error} = Server.from_region(context.bad_region)
      assert error === "region [] is incorrect or not supported"
    end
  end
end
