defmodule BlitzElixirProject.Tracker.Notifier do
  alias BlitzElixirProject.Riot

  def notify(state), do: update_match_status(state)

  def update_match_status(%{summoner: summoner, last_match_id: last_match_id} = state) do
    case is_next_match?(summoner, last_match_id) do
      {true, new_match_id} ->
        log_to_console(summoner.name, new_match_id)
        Map.replace(state, :last_match_id, new_match_id)
      _ ->
        state
    end
  end

  def is_next_match?(summoner, last_match_id) do
    with {:ok, [match_id | _]} <- Riot.fetch_match_ids_by_puuid(summoner.region, summoner.puuid, 1) do
      if match_id !== last_match_id do
        {true, match_id}
      else
        false
      end
    else
      _ -> false
    end
  end

  def log_to_console(name, match_id), do: IO.puts("Summoner #{name} completed match #{match_id}")
end
