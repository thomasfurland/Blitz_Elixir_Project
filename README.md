# BlitzElixirProject

## Instruction

Add **:api_key** to **:blitz_elixir_project** key for desired config environment file.

Run Summoner Tracking Function with:
```elixir
BlitzElixirProject.track_recent_opponents("user", "region")
```
Regions [euw1, na1, jp1] implemented, this can be altered via config.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `blitz_elixir_project` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:blitz_elixir_project, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/blitz_elixir_project>.

