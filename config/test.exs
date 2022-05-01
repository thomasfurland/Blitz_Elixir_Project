import Config

config :logger, level: :warn

config :blitz_elixir_project,
  http: BlitzElixirProject.TestHTTP,
  notifier: BlitzElixirProject.TestNotifier,
  tracker_expiry: 5000,
  tracker_interval: 500,
  api_key: ""
