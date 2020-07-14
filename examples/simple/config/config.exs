# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

#config :app_user, Game.Repo,
#  database: "app_user_repo",
#  username: "user",
#  password: "pass",
#  hostname: "localhost"
#
#config :app_user, ecto_repos: [Sample.Repo]

config :simple, ecto_repos: [Sample.Repo]

config :simple,
       Sample.Repo,
       database: "ecto_simple",
       username: "postgres",
       password: "postgres",
       hostname: "localhost",
       port: "5432",
       show_sensitive_data_on_connection_error: true
       #pool_size: 10

config :ecto_south, :mods,
       [Sample.Weather]

config :ecto_south, :path,
       data_path: "./priv/repo/migrations.exs",
       migrate_path: "./priv/repo/migrations"
