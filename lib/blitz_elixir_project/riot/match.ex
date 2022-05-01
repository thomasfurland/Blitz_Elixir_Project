defmodule BlitzElixirProject.Riot.Match do
  defstruct [:region, :match_id, :participants]

  def from_map(%{
    "region" => region,
    "metadata" =>
      %{
        "matchId" => match_id,
        "participants" => participants
      }
    })
  do
    %__MODULE__{
      region: region,
      match_id: match_id,
      participants: participants
    }
  end
end
