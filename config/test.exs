use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :curry_time, CurryTime.Repo,
  username: "postgres",
  password: "postgres",
  database: "curry_time_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :curry_time, CurryTimeWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Ueberauth github config for dev
config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "e3d3f9ed37a4dacdd02d",
  client_secret: "95d5739132f60b0f38a60907c3381888a0c6674a"
