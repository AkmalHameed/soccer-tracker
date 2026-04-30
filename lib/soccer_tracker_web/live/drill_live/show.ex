defmodule SoccerTrackerWeb.DrillLive.Show do
  use SoccerTrackerWeb, :live_view

  alias SoccerTracker.Training

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@drill.name}
        <:subtitle>Drill details</:subtitle>
        <:actions>
          <.button navigate={~p"/drills"}>
            <.icon name="hero-arrow-left" /> Back
          </.button>
          <.button variant="primary" navigate={~p"/drills/#{@drill}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit drill
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@drill.name}</:item>
        <:item title="Sets">{@drill.sets}</:item>
        <:item title="Reps">{@drill.reps}</:item>
        <:item title="Duration">{@drill.duration} minutes</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Drill Details")
     |> assign(:drill, Training.get_drill!(socket.assigns.current_scope, id))}
  end
end
