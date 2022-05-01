import Config

config :logger, level: :warn

config :blitz_elixir_project,
  http: BlitzElixirProject.TestHTTP,
  notifier: BlitzElixirProject.TestNotifier,
  tracker_expiry: 100,
  tracker_interval: 50,
  api_key: ""
