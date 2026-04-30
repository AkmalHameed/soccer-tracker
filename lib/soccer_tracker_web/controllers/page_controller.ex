defmodule SoccerTrackerWeb.PageController do
  use SoccerTrackerWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
