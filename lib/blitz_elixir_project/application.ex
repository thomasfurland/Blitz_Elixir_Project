defmodule BlitzElixirProject.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {BlitzElixirProject.Tracker.TrackingList, %{}},
      {DynamicSupervisor, strategy: :one_for_one, name: BlitzElixirProject.TrackerSupervisor},
      {Registry, keys: :unique, name: BlitzElixirProject.Registry}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BlitzElixirProject.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
