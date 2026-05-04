defmodule SoccerTrackerWeb.PageController do
  use SoccerTrackerWeb, :controller

  def home(conn, _params) do
    if conn.assigns[:current_scope] do
      redirect(conn, to: ~p"/dashboard")
    else
      render(conn, :home)
    end
  end

  def privacy(conn, _params) do
    render(conn, :privacy)
  end

  def support(conn, _params) do
    render(conn, :support)
  end
end
