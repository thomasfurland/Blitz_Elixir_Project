defmodule BlitzElixirProject.Riot.HelperTest do
  use ExUnit.Case, async: true

  alias BlitzElixirProject.Riot.Helper

  describe "accumulate_unique_results/1" do
    test "success: accumulates list of :ok and :error tuples" do
      stream = [
        {:ok, {:ok, 1..10}},
        {:ok, {:ok, 6..15}},
        {:ok, {:error, "error"}},
        {:error, "crash"}
      ]
      assert {%MapSet{} = result, errors} = Helper.accumulate_unique_results(stream)
      assert MapSet.to_list(result) === Enum.to_list(1..15)
      assert length(errors) === 2
    end
  end

  describe "add_unique_ids/2" do
    test "success: add ids to set" do
      ids = MapSet.new(1..15)
      new_ids = 6..20

      assert %MapSet{} = result = Helper.add_unique_result(ids, new_ids)
      assert MapSet.to_list(result) === Enum.to_list(1..20)
    end
  end

  describe "accumulate_results/1" do
    test "success: accumulates list of :ok and :error tuples" do
      stream = [
        {:ok, {:ok, "value1"}},
        {:ok, {:ok, "value2"}},
        {:ok, {:error, "error"}},
        {:error, "crash"}
      ]
      assert {results, errors} = Helper.accumulate_results(stream)
      assert length(results) === 2
      assert length(errors) === 2
    end
  end

  describe "get_url/3" do
    test "success: return valid url string" do
      assert {:ok, url} = Helper.get_url("http://www.fake.com/", "/fake_path", %{fakekey: "fakeparam"})
      assert url === "http://www.fake.com/fake_path?fakekey=fakeparam"
    end

    test "failure: invalid character in url" do
      assert {:error, _} = Helper.get_url("http://www.fa\\e.com/", "/fake_path", %{fakekey: "fakeparam"})
    end
  end
end
