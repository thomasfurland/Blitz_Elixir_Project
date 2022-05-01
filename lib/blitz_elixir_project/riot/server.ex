defmodule BlitzElixirProject.Riot.Server do
  defstruct [:region_uri, :continent_uri]

  @type t :: %__MODULE__{region_uri: String.t, continent_uri: String.t}

  alias BlitzElixirProject.Config

  @spec from_region(any) :: {:error, String.t} | {:ok, __MODULE__.t}
  def from_region(region) do
    case get_continental_uri(region) do
      nil -> {:error, "region is incorrect or not supported"}
      uri ->
        server = %__MODULE__{region_uri: Map.get(Config.regional_uris(), region), continent_uri: uri}
        {:ok, server}
    end
  end

  defp get_continental_uri(region) do
    cond do
      region in Config.europe_servers() -> Map.get(Config.continental_uris(), :europe)
      region in Config.americas_servers() -> Map.get(Config.continental_uris(), :americas)
      region in Config.asia_servers() -> Map.get(Config.continental_uris(), :asia)
      true -> nil
    end
  end
end
