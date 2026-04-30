defmodule SoccerTrackerWeb.GoalLive.Show do
  use SoccerTrackerWeb, :live_view

  alias SoccerTracker.Training

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@goal.type}
        <:subtitle>Goal details</:subtitle>
        <:actions>
          <.button navigate={~p"/goals"}>
            <.icon name="hero-arrow-left" /> Back
          </.button>
          <.button variant="primary" navigate={~p"/goals/#{@goal}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit goal
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Goal">{@goal.type}</:item>
        <:item title="Target">{@goal.target}</:item>
        <:item title="Current Progress">{@goal.current_value}</:item>
        <:item title="Deadline">{@goal.deadline}</:item>
      </.list>

      <div class="mt-6">
        <progress class="progress progress-primary w-full" value={@goal.current_value} max={@goal.target} />
        <p class="text-sm opacity-60 mt-1">{Float.round(@goal.current_value / @goal.target * 100, 1)}% complete</p>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Goal Details")
     |> assign(:goal, Training.get_goal!(socket.assigns.current_scope, id))}
  end
end
