# EctoSouth

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ecto_south` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ecto_south, "~> 0.1.2"}]
end
```
or

```elixir
def deps do
  [{:ecto_south, github: "360ekh/ecto_south"}]
end
```

Add :ecto_south to your mix application
```
applications: [:ecto_south]]
```
Add model config to your project config.exs

```elixir
config :ecto_south, :mods,
  [Simple.Weather]    #your project model module
```

Run cmd
```
mix south
```
ecto_south will check your model chenges and atuo create migrations File on your project. (./priv/repo/migrations)
