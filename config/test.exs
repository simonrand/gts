use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :gts, Gts.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :gts, Gts.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "simon",
  password: "",
  database: "gts_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :gts, Gts.AES,
  key: "9Xx7AG7Yrr5odsb940mYBg8tKF799W69"
