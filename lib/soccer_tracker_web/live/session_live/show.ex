defmodule SoccerTrackerWeb.SessionLive.Show do
  use SoccerTrackerWeb, :live_view

  alias SoccerTracker.Training

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Session — {@session.date}
        <:subtitle>{@session.type}</:subtitle>
        <:actions>
          <.button navigate={~p"/sessions"}>
            <.icon name="hero-arrow-left" /> Back
          </.button>
          <.button variant="primary" navigate={~p"/sessions/#{@session}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit session
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Date">{@session.date}</:item>
        <:item title="Type">{@session.type}</:item>
        <:item title="Duration">{@session.duration} minutes</:item>
        <:item title="Distance">{@session.distance} km</:item>
        <:item title="Notes">{@session.notes || "—"}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Session Details")
     |> assign(:session, Training.get_session!(socket.assigns.current_scope, id))}
  end
end
