# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :gts, Gts.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "gts_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"


# Configures the endpoint
config :gts, Gts.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "gisvvoxTgN/RWdqISaU99yVDN6RgnNF8hsILGZ4wfZd9sCN/GlarrlSBNRGi9hg3",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Gts.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

# ueberauth
config :ueberauth, Ueberauth,
  providers: [
    github: { Ueberauth.Strategy.Github, [default_scope: "user,repo"] }
  ]
