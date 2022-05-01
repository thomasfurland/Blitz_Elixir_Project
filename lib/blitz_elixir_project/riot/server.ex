defmodule BlitzElixirProject.Riot.Server do
  defstruct [:region_uri, :continent_uri]

  @type t :: %__MODULE__{region_uri: String.t, continent_uri: String.t}

  alias BlitzElixirProject.Config

  @spec from_region(any) :: {:error, String.t} | {:ok, __MODULE__.t}
  def from_region(region) do
    case get_uris(region) do
      {c, r} when is_nil(c) or is_nil(r) -> {:error, "region [#{region}] is incorrect or not supported"}
      {cont_uri, reg_uri} -> {:ok, %__MODULE__{region_uri: reg_uri, continent_uri: cont_uri}}
    end
  end

  defp get_uris(region), do: {get_continental_uri(region), get_regional_uri(region)}

  defp get_continental_uri(region) do
    cond do
      region in Config.europe_servers() -> Map.get(Config.continental_uris(), :europe)
      region in Config.americas_servers() -> Map.get(Config.continental_uris(), :americas)
      region in Config.asia_servers() -> Map.get(Config.continental_uris(), :asia)
      true -> nil
    end
  end

  defp get_regional_uri(region), do: Map.get(Config.regional_uris(), region)
end
