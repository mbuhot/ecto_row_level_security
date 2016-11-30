# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :learnrls,
  ecto_repos: [Learnrls.Repo]

# Configures the endpoint
config :learnrls, Learnrls.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "S65pS+JM1puTebHUl7pGwP4KyPzV7vv5opfgfhGXoiC9ZGzuJJZ+wj2RYfCH1dwd",
  render_errors: [view: Learnrls.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Learnrls.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
