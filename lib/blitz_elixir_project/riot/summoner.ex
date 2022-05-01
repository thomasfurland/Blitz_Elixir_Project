defmodule BlitzElixirProject.Riot.Summoner do
  defstruct [:region, :name, :puuid]

  @type t :: %__MODULE__{region: String.t, name: String.t, puuid: String.t}

  @spec from_map(map) :: __MODULE__.t
  def from_map(%{"region" => region, "name" => name, "puuid" => puuid}) do
    %__MODULE__{
      region: region,
      name: name,
      puuid: puuid
    }
  end
end
