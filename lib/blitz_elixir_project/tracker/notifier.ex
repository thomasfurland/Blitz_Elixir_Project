defmodule BlitzElixirProject.Tracker.Notifier do
  alias BlitzElixirProject.Riot

  @spec notify(map) :: map
  def notify(state), do: update_match_status(state)

  @spec update_match_status(%{last_match_id: String.t, summoner: Riot.Summoner.t()}) :: map
  def update_match_status(%{summoner: summoner, last_match_id: last_match_id} = state) do
    case is_next_match?(summoner, last_match_id) do
      {true, new_match_id} ->
        log_to_console(summoner.name, new_match_id)
        Map.replace(state, :last_match_id, new_match_id)
      _ ->
        state
    end
  end

  @spec is_next_match?(Riot.Summoner.t, String.t) :: {true, String.t} | false
  def is_next_match?(summoner, last_match_id) do
    with {:ok, [match_id | _]} <- Riot.fetch_match_ids_by_puuid(summoner.puuid, 1, summoner.region) do
      if match_id !== last_match_id do
        {true, match_id}
      else
        false
      end
    else
      _ -> false
    end
  end

  @spec log_to_console(String.t, String.t) :: :ok
  def log_to_console(name, match_id), do: IO.puts("Summoner #{name} completed match #{match_id}")
end
