defmodule BlitzElixirProject.Riot.Summoner do
  defstruct [:region, :name, :puuid]

  def from_map(%{"region" => region, "name" => name, "puuid" => puuid}) do
    %__MODULE__{
      region: region,
      name: name,
      puuid: puuid
    }
  end
end
