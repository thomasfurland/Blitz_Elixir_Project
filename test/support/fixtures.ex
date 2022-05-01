defmodule BlitzElixirProject.Fixtures do

  alias BlitzElixirProject.Riot

  def valid_summoner() do
    %Riot.Summoner{
      name: "Babus",
      puuid: "x4GP5BPWiOyM11HVkVa1HQsr8bzW-SqGxKvoA-GGh3_x-I9dwJ4iy-OjPe6zcAEsaciPn-I4R9poAA",
      region: "euw1",
    }
  end

end
