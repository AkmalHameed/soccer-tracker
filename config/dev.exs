import Config

config :soccer_tracker, SoccerTracker.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "127.0.0.1",
  database: "soccer_tracker_dev",
  port: 5433,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :soccer_tracker, SoccerTrackerWeb.Endpoint,

  http: [ip: {127, 0, 0, 1}],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "pwb9tyXl86za4hnqoq6wsduCS1eWtb3p2WxtONd+cZA/B05OeWcUHr2jvNQxUNgU",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:soccer_tracker, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:soccer_tracker, ~w(--watch)]}
  ]

config :soccer_tracker, SoccerTrackerWeb.Endpoint,
  live_reload: [
    web_console_logger: true,
    patterns: [
      ~r"priv/static/(?!uploads/).*\.(js|css|png|jpeg|jpg|gif|svg)$"E,
      ~r"priv/gettext/.*\.po$"E,
      ~r"lib/soccer_tracker_web/router\.ex$"E,
      ~r"lib/soccer_tracker_web/(controllers|live|components)/.*\.(ex|heex)$"E
    ]
  ]

config :soccer_tracker, dev_routes: true

config :logger, :default_formatter, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  debug_heex_annotations: true,
  debug_attributes: true,
  enable_expensive_runtime_checks: true

config :swoosh, :api_client, false
