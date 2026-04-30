defmodule SoccerTracker.Application do


  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SoccerTrackerWeb.Telemetry,
      SoccerTracker.Repo,
      {DNSCluster, query: Application.get_env(:soccer_tracker, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SoccerTracker.PubSub},
      SoccerTrackerWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: SoccerTracker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    SoccerTrackerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
