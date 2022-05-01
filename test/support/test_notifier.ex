defmodule BlitzElixirProject.TestNotifier do
  def notify(%{pid: pid} = state) do
    send(pid, :hello)
    state
  end
end
