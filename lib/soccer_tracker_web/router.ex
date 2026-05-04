defmodule SoccerTrackerWeb.Router do
  use SoccerTrackerWeb, :router

  import SoccerTrackerWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SoccerTrackerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SoccerTrackerWeb do
    pipe_through :browser
    get "/", PageController, :home
    get "/privacy", PageController, :privacy
    get "/support", PageController, :support
  end

  if Application.compile_env(:soccer_tracker, :dev_routes) do
    import Phoenix.LiveDashboard.Router
    scope "/dev" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: SoccerTrackerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/", SoccerTrackerWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{SoccerTrackerWeb.UserAuth, :require_authenticated}] do

      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email

      live "/dashboard", DashboardLive, :index
      live "/sessions", SessionLive.Index, :index
      live "/sessions/new", SessionLive.Form, :new
      live "/sessions/:id", SessionLive.Show, :show
      live "/sessions/:id/edit", SessionLive.Form, :edit
      live "/drills", DrillLive.Index, :index
      live "/drills/new", DrillLive.Form, :new
      live "/drills/:id", DrillLive.Show, :show
      live "/drills/:id/edit", DrillLive.Form, :edit
      live "/goals", GoalLive.Index, :index
      live "/goals/new", GoalLive.Form, :new
      live "/goals/:id", GoalLive.Show, :show
      live "/goals/:id/edit", GoalLive.Form, :edit
      live "/games", GameLogLive.Index, :index
      live "/games/new", GameLogLive.Form, :new
      live "/games/:id", GameLogLive.Show, :show
      live "/games/:id/edit", GameLogLive.Form, :edit
      live "/teams", TeamLive.Index, :index
      live "/teams/new", TeamLive.Form, :new
      live "/teams/:id", TeamLive.Show, :show
      live "/teams/join/:token", TeamLive.Join, :index
      live "/library", LibraryLive.Index, :index
      live "/programs", ProgramLive.Index, :index
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/", SoccerTrackerWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{SoccerTrackerWeb.UserAuth, :mount_current_scope}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end
end
