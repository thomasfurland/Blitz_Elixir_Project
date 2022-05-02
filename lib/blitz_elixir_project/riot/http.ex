defmodule BlitzElixirProject.Riot.HTTP do

  @type http_response :: %{body: any(), status_code: any()}

  alias BlitzElixirProject.Riot.{Match, Summoner, Server, Helper}
  alias BlitzElixirProject.Config

  @spec summoners_by_name(String.t, String.t) ::
          {:error, binary | HTTPoison.Error.t | Jason.DecodeError.t | http_response} | {:ok, Summoner.t}
  def summoners_by_name(name, region) do
    with {:ok, response} <- regional_request("/lol/summoner/v4/summoners/by-name/#{name}", region) do
      {:ok, summoner_from_response(response, region)}
    end
  end

  defp summoner_from_response(response, region) do
    response
    |> Map.put("region", region)
    |> Summoner.from_map()
  end

  @spec summoners_by_puuid(String.t, String.t) ::
          {:error, binary | HTTPoison.Error.t | Jason.DecodeError.t | http_response} | {:ok, Summoner.t}
  def summoners_by_puuid(puuid, region) do
    with {:ok, response} <- regional_request("/lol/summoner/v4/summoners/by-puuid/#{puuid}", region) do
      {:ok, summoner_from_response(response, region)}
    end
  end

  @spec matches_by_puuid(String.t, String.t, integer) ::
          {:error, binary | HTTPoison.Error.t | Jason.DecodeError.t | http_response} | {:ok, list}
  def matches_by_puuid(puuid, count, region) do
    continental_request("/lol/match/v5/matches/by-puuid/#{puuid}/ids", region, %{count: count})
  end

  @spec matches(String.t, String.t) ::
          {:error, binary | HTTPoison.Error.t | Jason.DecodeError.t | http_response} | {:ok, Match.t}
  def matches(match_id, region) do
    with {:ok, response} <- continental_request("/lol/match/v5/matches/#{match_id}", region) do
      {:ok, match_from_response(response, region)}
    end
  end

  defp match_from_response(response, region) do
    response
    |> Map.put("region", region)
    |> Match.from_map()
  end

  defp regional_request(url_path, region, params \\ %{}) do
    params = Map.put(params, :api_key, Config.api_key())
    with {:ok, server} <- Server.from_region(region),
         {:ok, url} <- Helper.get_url(server.region_uri, url_path, params)
    do
      send_request(url)
    end
  end

  defp continental_request(url_path, region, params \\ %{}) do
    params = Map.put(params, :api_key, Config.api_key())
    with {:ok, server} <- Server.from_region(region),
         {:ok, url} <- Helper.get_url(server.continent_uri, url_path, params)
    do
      send_request(url)
    end
  end

  defp send_request(url) do
    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(url),
         {:ok, response_body} <- Jason.decode(body)
    do
      {:ok, response_body}
    else
      {:ok, %HTTPoison.Response{body: body, status_code: status}} -> {:error, %{body: body, status_code: status}}
      error -> error
    end
  end
end
