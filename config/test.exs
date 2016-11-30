use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :learnrls, Learnrls.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :learnrls, Learnrls.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "learnrls_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
