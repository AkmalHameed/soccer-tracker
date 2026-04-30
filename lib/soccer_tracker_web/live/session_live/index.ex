defmodule SoccerTrackerWeb.SessionLive.Index do
  use SoccerTrackerWeb, :live_view

  alias SoccerTracker.Training

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <.header>
        Listing Sessions
        <:actions>
          <.button variant="primary" navigate={~p"/sessions/new"}>
            <.icon name="hero-plus" /> New Session
          </.button>
        </:actions>
      </.header>

      <.table
        id="sessions"
        rows={@streams.sessions}
        row_click={fn {_id, session} -> JS.navigate(~p"/sessions/#{session}") end}
      >
        <:col :let={{_id, session}} label="Date">{session.date}</:col>
        <:col :let={{_id, session}} label="Type">{session.type}</:col>
        <:col :let={{_id, session}} label="Duration">{session.duration} min</:col>
        <:col :let={{_id, session}} label="Distance">{session.distance} km</:col>
        <:col :let={{_id, session}} label="Notes">{session.notes}</:col>
        <:action :let={{_id, session}}>
          <div class="sr-only">
            <.link navigate={~p"/sessions/#{session}"}>Show</.link>
          </div>
          <.link navigate={~p"/sessions/#{session}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, session}}>
          <.link
            phx-click={JS.push("delete", value: %{id: session.id}) |> hide("##{id}")}
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
     |> assign(:page_title, "Listing Sessions")
     |> stream(:sessions, Training.list_sessions(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    session = Training.get_session!(socket.assigns.current_scope, id)
    {:ok, _} = Training.delete_session(socket.assigns.current_scope, session)
    {:noreply, stream_delete(socket, :sessions, session)}
  end
end
