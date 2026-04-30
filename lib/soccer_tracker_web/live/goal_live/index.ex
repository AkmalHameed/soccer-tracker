defmodule SoccerTrackerWeb.GoalLive.Index do
  use SoccerTrackerWeb, :live_view

  alias SoccerTracker.Training

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <.header>
        My Goals
        <:actions>
          <.button variant="primary" navigate={~p"/goals/new"}>
            <.icon name="hero-plus" /> New Goal
          </.button>
        </:actions>
      </.header>

      <.table
        id="goals"
        rows={@streams.goals}
        row_click={fn {_id, goal} -> JS.navigate(~p"/goals/#{goal}") end}
      >
        <:col :let={{_id, goal}} label="Goal">{goal.type}</:col>
        <:col :let={{_id, goal}} label="Progress">{goal.current_value} / {goal.target}</:col>
        <:col :let={{_id, goal}} label="Deadline">{goal.deadline}</:col>
        <:action :let={{_id, goal}}>
          <div class="sr-only">
            <.link navigate={~p"/goals/#{goal}"}>Show</.link>
          </div>
          <.link navigate={~p"/goals/#{goal}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, goal}}>
          <.link
            phx-click={JS.push("delete", value: %{id: goal.id}) |> hide("##{id}")}
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
     |> assign(:page_title, "My Goals")
     |> stream(:goals, Training.list_goals(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    goal = Training.get_goal!(socket.assigns.current_scope, id)
    {:ok, _} = Training.delete_goal(socket.assigns.current_scope, goal)
    {:noreply, stream_delete(socket, :goals, goal)}
  end
end
