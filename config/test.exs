import Config

config :pbkdf2_elixir, :rounds, 1

config :soccer_tracker, SoccerTracker.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "soccer_tracker_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :soccer_tracker, SoccerTrackerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "SujzLq3lf9UOilgfJczxgxe7PwNas1jrM1Zsb6MzFC/YGXayckDzUytgbiqocL9f",
  server: false

config :soccer_tracker, SoccerTracker.Mailer, adapter: Swoosh.Adapters.Test

config :swoosh, :api_client, false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  enable_expensive_runtime_checks: true

config :phoenix,
  sort_verified_routes_query_params: true
