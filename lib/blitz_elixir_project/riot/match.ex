defmodule BlitzElixirProject.Riot.Match do
  defstruct [:region, :match_id, :participants]

  @type t :: %__MODULE__{
    region: String.t,
    match_id: String.t,
    participants: list(String.t)
  }

  @spec from_map(map) :: __MODULE__.t
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
