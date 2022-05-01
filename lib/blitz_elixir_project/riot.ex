defmodule BlitzElixirProject.Riot do

  @type http_response :: %{body: any(), status_code: any()}

  alias BlitzElixirProject.Riot.{Match, Summoner, Helper}
  alias BlitzElixirProject.Config

  @spec fetch_summoner_by_name(String.t, String.t) ::
          {:error, binary | HTTPoison.Error.t | Jason.DecodeError.t | http_response} | {:ok, Summoner.t}
  def fetch_summoner_by_name(name, region) do
    http_module = Config.http()
    http_module.summoners_by_name(name, region)
  end

  @spec fetch_summoner_by_puuid(String.t, String.t) ::
  {:error, binary | HTTPoison.Error.t | Jason.DecodeError.t | http_response} | {:ok, Summoner.t}
  def fetch_summoner_by_puuid(puuid, region) do
    http_module = Config.http()
    http_module.summoners_by_puuid(puuid, region)
  end

  @spec fetch_match(String.t, String.t) ::
          {:error, binary | HTTPoison.Error.t | Jason.DecodeError.t | http_response} | {:ok, Match.t}
  def fetch_match(match_id, region) do
    http_module = Config.http()
    http_module.matches(match_id, region)
  end

  @spec fetch_match_ids_by_puuid(any, any, any) ::
          {:error, binary | HTTPoison.Error.t | Jason.DecodeError.t | http_response} | {:ok, list}
  def fetch_match_ids_by_puuid(puuid, count, region) do
    http_module = Config.http()
    http_module.matches_by_puuid(puuid, count, region)
  end

  @spec fetch_recently_played_summoners(Summoner.t, integer) ::
          {:error, binary | HTTPoison.Error.t | Jason.DecodeError.t | http_response} | {:ok, [Summoner.t]}
  def fetch_recently_played_summoners(%Summoner{region: region, puuid: puuid}, matches_count) do
    with {:ok, match_ids} <- fetch_match_ids_by_puuid(puuid, matches_count, region),
         {:ok, summoner_ids} <- fetch_summoner_ids_from_matches(match_ids, region),
         {:ok, summoners} <- fetch_summoners_by_ids(Helper.remove_id(summoner_ids, puuid), region) #removing calling summoners id
    do
      {:ok, summoners}
    end
  end

  @spec fetch_summoner_ids_from_matches(any, any) :: {:error, list} | {:ok, [String.t]}
  def fetch_summoner_ids_from_matches(matches, region) do
    case concurrently_fetch_participants_from_matches(matches, region) do
      {_, errors} when errors !== [] -> {:error, errors}
      {summoner_ids, _} -> {:ok, MapSet.to_list(summoner_ids)}
    end
  end

  defp concurrently_fetch_participants_from_matches(matches, region) do
    matches
    |> Task.async_stream(&(fetch_participants_from_match(&1, region)), ordered: false)
    |> Helper.accumulate_unique_results
  end

  defp fetch_participants_from_match(match_id, region) do
    with {:ok, %Match{} = match} <- fetch_match(match_id, region) do
      {:ok, match.participants}
    end
  end

  @spec fetch_summoners_by_ids(any, any) :: {:error, list} | {:ok, [Summoner.t]}
  def fetch_summoners_by_ids(ids, region) do
    case concurrently_fetch_summoners_by_puuids(ids, region) do
      {_, errors} when errors !== [] -> {:error, errors}
      {summoners, _} -> {:ok, summoners}
    end
  end

  defp concurrently_fetch_summoners_by_puuids(puuids, region) do
    puuids
    |> Task.async_stream(&(fetch_summoner_by_puuid(&1, region)), ordered: false)
    |> Helper.accumulate_results
  end
end
