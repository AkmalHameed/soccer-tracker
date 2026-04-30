defmodule SoccerTracker.Repo do
  use Ecto.Repo,
    otp_app: :soccer_tracker,
    adapter: Ecto.Adapters.Postgres
end
