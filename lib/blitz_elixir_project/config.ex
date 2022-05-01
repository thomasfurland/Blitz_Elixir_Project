defmodule BlitzElixirProject.Config do

  @europe ["euw1", "eun1", "tr1", "ru"]
  @americas ["na1", "br1", "la1", "la2", "oce"]
  @asia ["jp1", "kr"]

  @regional_uris %{
    "euw1" => "https://euw1.api.riotgames.com/",
    "na1" => "https://na1.api.riotgames.com/",
    "jp1" => "https://jp1.api.riotgames.com/"
  }

  @continental_uris %{
    :europe => "https://europe.api.riotgames.com/",
    :americas => "https://americas.api.riotgames.com/",
    :asia => "https://asia.api.riotgames.com/"
  }

  def http, do: Application.get_env(:blitz_elixir_project, :http) || BlitzElixirProject.Riot.HTTP
  def notifier, do: Application.get_env(:blitz_elixir_project, :notifier) || BlitzElixirProject.Tracker.Notifier
  def api_key, do: Application.get_env(:blitz_elixir_project, :api_key) || ""
  def tracker_expiry, do: Application.get_env(:blitz_elixir_project, :tracker_expiry) || 1000 * 60 * 60
  def tracker_interval, do: Application.get_env(:blitz_elixir_project, :tracker_interval) || 1000 * 60

  def regional_uris, do: Application.get_env(:blitz_elixir_project, :regional_uris) || @regional_uris
  def continental_uris, do: Application.get_env(:blitz_elixir_project, :continental_uris) || @continental_uris
  def europe_servers, do: Application.get_env(:blitz_elixir_project, :europe_servers) || @europe
  def americas_servers, do: Application.get_env(:blitz_elixir_project, :americas_servers) || @americas
  def asia_servers, do: Application.get_env(:blitz_elixir_project, :asia_servers) || @asia


end
