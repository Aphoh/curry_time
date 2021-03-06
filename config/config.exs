# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :curry_time,
  ecto_repos: [CurryTime.Repo]

# Configures the endpoint
config :curry_time, CurryTimeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2WdH5UoRCRMZ454XaO0l4+RJLq2fNzPNpBeTT2CoWBnDHJ1ewCqJgPBwNE4pEo3A",
  render_errors: [view: CurryTimeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: CurryTime.PubSub,
  live_view: [signing_salt: "OJRv38vx"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Ueberauth config
config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user:email"]}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
