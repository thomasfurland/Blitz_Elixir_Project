defmodule BlitzElixirProject.Riot.HTTP do

  alias BlitzElixirProject.Riot.{Match, Summoner, Server}
  alias BlitzElixirProject.Config

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
