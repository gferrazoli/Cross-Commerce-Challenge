import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :challenge, Challenge.Repo,
  username: "postgres",
  password: "postgres",
  database: "challenge_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :challenge, ChallengeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "d9xJ1xY/jdDZJ4uhwRyNOsv4NIqxLIrqNkJNvTnA2K9j9yOiLMCzc1G3/uq/5VCV",
  server: false

# In test we don't send emails.
config :challenge, Challenge.Mailer, adapter: Swoosh.Adapters.Test

config :challenge,
  request_module: Challenge.Requests.Request.Mock

config :challenge,
  chunk_size: 2

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
