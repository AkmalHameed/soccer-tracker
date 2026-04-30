import Config

config :soccer_tracker, SoccerTrackerWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"

config :soccer_tracker, SoccerTrackerWeb.Endpoint,
  force_ssl: [
    rewrite_on: [:x_forwarded_proto],
    exclude: [
      hosts: ["localhost", "127.0.0.1"]
    ]
  ]

config :swoosh, api_client: Swoosh.ApiClient.Req

config :swoosh, local: false

config :logger, level: :info
