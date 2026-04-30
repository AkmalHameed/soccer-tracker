defmodule SoccerTrackerWeb.DrillLive.Index do
  use SoccerTrackerWeb, :live_view

  alias SoccerTracker.Training

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <.header>
        My Drills
        <:actions>
          <.button variant="primary" navigate={~p"/drills/new"}>
            <.icon name="hero-plus" /> New Drill
          </.button>
        </:actions>
      </.header>

      <.table
        id="drills"
        rows={@streams.drills}
        row_click={fn {_id, drill} -> JS.navigate(~p"/drills/#{drill}") end}
      >
        <:col :let={{_id, drill}} label="Name">{drill.name}</:col>
        <:col :let={{_id, drill}} label="Sets">{drill.sets}</:col>
        <:col :let={{_id, drill}} label="Reps">{drill.reps}</:col>
        <:col :let={{_id, drill}} label="Duration">{drill.duration} min</:col>
        <:action :let={{_id, drill}}>
          <div class="sr-only">
            <.link navigate={~p"/drills/#{drill}"}>Show</.link>
          </div>
          <.link navigate={~p"/drills/#{drill}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, drill}}>
          <.link
            phx-click={JS.push("delete", value: %{id: drill.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "My Drills")
     |> stream(:drills, Training.list_drills(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    drill = Training.get_drill!(socket.assigns.current_scope, id)
    {:ok, _} = Training.delete_drill(socket.assigns.current_scope, drill)
    {:noreply, stream_delete(socket, :drills, drill)}
  end
end
