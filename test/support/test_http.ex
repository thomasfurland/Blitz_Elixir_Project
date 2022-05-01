defmodule BlitzElixirProject.TestHTTP do

  def summoners_by_name("", _), do: {:error, %{body: "error", status_code: 9001}}
  def summoners_by_name(name, region) do
    {:ok, %BlitzElixirProject.Riot.Summoner{
      region: region,
      name: name,
      puuid: "0"}
    }
  end

  def summoners_by_puuid("", _), do: {:error, %{body: "error", status_code: 9001}}
  def summoners_by_puuid(puuid, region) do
    {:ok, %BlitzElixirProject.Riot.Summoner{
      region: region,
      name: "bob",
      puuid: puuid}
    }
  end

  def matches_by_puuid("", _, _), do: {:error, %{body: "error", status_code: 9001}}
  def matches_by_puuid(_region, _puuid, _count) do
    {:ok, ["1", "2", "3", "4", "5"]}
  end

  def matches("", _), do: {:error, %{body: "error", status_code: 9001}}
  def matches(match_id, region) do
    {:ok, %BlitzElixirProject.Riot.Match{
      region: region,
      match_id: match_id,
      participants: ["1","2","3","4","5"]}
    }
  end
end
