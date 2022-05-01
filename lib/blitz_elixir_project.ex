defmodule BlitzElixirProject do
  @moduledoc """
  Documentation for `BlitzElixirProject`.
  """
  @type http_response :: %{body: any(), status_code: any()}

  alias BlitzElixirProject.{Riot, Tracker}

  @spec get_and_track_recently_played_summoners(String.t, String.t, keyword) ::
          {:error, binary | HTTPoison.Error.t | Jason.DecodeError.t | http_response} | {:ok, [String.t]}
  def get_and_track_recently_played_summoners(summoner_name, region, opts \\ []) do
    with {:ok, %Riot.Summoner{} = summoner} <- Riot.fetch_summoner_by_name(summoner_name, region),
         {:ok, summoner_list} <- Riot.fetch_recently_played_summoners(summoner, opts[:matches] || 5),
         {:ok, _} <- Tracker.spawn_summoner_trackers(summoner_list, opts)
    do
      Enum.map(summoner_list, &(Map.get(&1, :name)))
    end
  end
end
