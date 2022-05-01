defmodule BlitzElixirProject.Riot.HTTP do

  @type http_response :: %{body: any(), status_code: any()}

  alias BlitzElixirProject.Riot.{Match, Summoner, Server}
  alias BlitzElixirProject.Config

  @spec summoners_by_name(String.t, String.t) ::
          {:error, binary | HTTPoison.Error.t | Jason.DecodeError.t | http_response} | {:ok, Summoner.t}
  def summoners_by_name(region, name) do
    path = "/lol/summoner/v4/summoners/by-name/#{name}"

    with {:ok, server} <- Server.from_region(region),
         {:ok, url} <- get_url(server.region_uri, path),
         {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(url),
         {:ok, response_body} <- Jason.decode(body)
    do
      summoner =
        response_body
        |> Map.put("region", region)
        |> Summoner.from_map()
      {:ok, summoner}
    else
      {:ok, %HTTPoison.Response{body: body, status_code: status}} -> {:error, %{body: body, status_code: status}}
      error -> error
    end
  end

  defp get_url(uri, path, params \\ %{}) do
    with {:ok, uri} <- URI.new(uri) do
      url =
        uri
        |> Map.replace(:path, path)
        |> Map.replace(:query, get_query(params))
        |> URI.to_string
      {:ok, url}
    end
  end

  defp get_query(params) do
    params
    |> Map.put("api_key", Config.api_key())
    |> URI.encode_query
  end

  @spec summoners_by_puuid(String.t, String.t) ::
          {:error, binary | HTTPoison.Error.t | Jason.DecodeError.t | http_response} | {:ok, Summoner.t}
  def summoners_by_puuid(region, puuid) do
    path = "/lol/summoner/v4/summoners/by-puuid/#{puuid}"

    with {:ok, server} <- Server.from_region(region),
         {:ok, url} <- get_url(server.region_uri, path),
         {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(url),
         {:ok, response_body} <- Jason.decode(body)
    do
      summoner =
        response_body
        |> Map.put("region", region)
        |> Summoner.from_map()
      {:ok, summoner}
    else
      {:ok, %HTTPoison.Response{body: body, status_code: status}} -> {:error, %{body: body, status_code: status}}
      error -> error
    end
  end

  @spec matches_by_puuid(String.t, String.t, integer) ::
          {:error, binary | HTTPoison.Error.t | Jason.DecodeError.t | http_response} | {:ok, list}
  def matches_by_puuid(region, puuid, count) do
    path = "/lol/match/v5/matches/by-puuid/#{puuid}/ids"
    params = %{"count" => count}
    with {:ok, server} <- Server.from_region(region),
         {:ok, url} <- get_url(server.continent_uri, path, params),
         {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(url),
         {:ok, response_body} <- Jason.decode(body)
    do
      {:ok, response_body}
    else
      {:ok, %HTTPoison.Response{body: body, status_code: status}} -> {:error, %{body: body, status_code: status}}
      error -> error
    end
  end

  @spec matches(String.t, String.t) ::
          {:error, binary | HTTPoison.Error.t | Jason.DecodeError.t | http_response} | {:ok, Match.t}
  def matches(region, match_id) do
    path = "/lol/match/v5/matches/#{match_id}"
    with {:ok, server} <- Server.from_region(region),
         {:ok, url} <- get_url(server.continent_uri, path),
         {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(url),
         {:ok, response_body} <- Jason.decode(body)
    do
      match =
        response_body
        |> Map.put("region", region)
        |> Match.from_map()
      {:ok, match}
    else
      {:ok, %HTTPoison.Response{body: body, status_code: status}} -> {:error, %{body: body, status_code: status}}
      error -> error
    end
  end
end
