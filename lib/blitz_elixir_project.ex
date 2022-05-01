defmodule BlitzElixirProject do
  @moduledoc """
  Documentation for `BlitzElixirProject`.
  """

  alias BlitzElixirProject.{Riot, Tracker}

  def get_and_track_recently_played_summoners(summoner_name, region, opts \\ []) do
    with {:ok, %Riot.Summoner{} = summoner} <- Riot.fetch_summoner_by_name(summoner_name, region),
         {:ok, summoner_list} <- Riot.fetch_recently_played_summoners(summoner, opts[:matches] || 5),
         {:ok, _} <- Tracker.spawn_summoner_trackers(summoner_list, opts)
    do
      summoner_list
    end
  end
end
