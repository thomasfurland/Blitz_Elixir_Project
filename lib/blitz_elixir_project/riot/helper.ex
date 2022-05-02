defmodule BlitzElixirProject.Riot.Helper do

  @spec remove_id(list, any) :: list
  def remove_id(ids, id), do: List.delete(ids, id)

  @spec accumulate_unique_results(any) :: any
  def accumulate_unique_results(stream), do: Enum.reduce(stream, {MapSet.new(), []}, &accumulate_unique_result/2)
  defp accumulate_unique_result({:ok, {:ok, result}}, {results, errors}), do: {add_unique_result(results, result), errors}
  defp accumulate_unique_result({:ok, {:error, _} = error}, {results, errors}), do: {results, [error | errors]}
  defp accumulate_unique_result({:error, error}, {results, errors}), do: {results, [error | errors]}

  @spec add_unique_result(MapSet.t(any), any) :: MapSet.t(any)
  def add_unique_result(id_set, id_list) do
    id_list
    |> MapSet.new
    |> MapSet.union(id_set)
  end

  @spec accumulate_results(any) :: any
  def accumulate_results(stream), do: Enum.reduce(stream, {[], []}, &accumulate_result/2)
  defp accumulate_result({:ok, {:ok, result}}, {results, errors}), do: {[result | results], errors}
  defp accumulate_result({:ok, {:error, _} = error}, {results, errors}), do: {results, [error | errors]}
  defp accumulate_result({:error, error}, {results, errors}), do: {results, [error | errors]}

  @spec get_url(String.t | URI.t(), String.t, map) :: {:error, String.t} | {:ok, String.t}
  def get_url(uri, path, params) do
    with {:ok, uri} <- URI.new(uri) do
      url =
        uri
        |> Map.replace(:path, path)
        |> Map.replace(:query, URI.encode_query(params))
        |> URI.to_string
      {:ok, url}
    end
  end
end
