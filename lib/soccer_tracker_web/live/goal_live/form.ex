defmodule SoccerTrackerWeb.GoalLive.Form do
  use SoccerTrackerWeb, :live_view

  alias SoccerTracker.Training
  alias SoccerTracker.Training.Goal

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Set and track your training goals.</:subtitle>
      </.header>

      <.form for={@form} id="goal-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:type]} type="text" label="Goal Description" placeholder="e.g. Run 5km, Score 10 goals" />
        <.input field={@form[:target]} type="number" label="Target Value" step="0.1" min="0.1" />
        <.input field={@form[:current_value]} type="number" label="Current Value" step="0.1" min="0" />
        <.input field={@form[:deadline]} type="date" label="Deadline" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Goal</.button>
          <.button navigate={return_path(@return_to, @goal)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    goal = Training.get_goal!(socket.assigns.current_scope, id)
    socket
    |> assign(:page_title, "Edit Goal")
    |> assign(:goal, goal)
    |> assign(:form, to_form(Training.change_goal(goal)))
  end

  defp apply_action(socket, :new, _params) do
    goal = %Goal{}
    socket
    |> assign(:page_title, "New Goal")
    |> assign(:goal, goal)
    |> assign(:form, to_form(Training.change_goal(goal)))
  end

  @impl true
  def handle_event("validate", %{"goal" => goal_params}, socket) do
    changeset = Training.change_goal(socket.assigns.goal, goal_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"goal" => goal_params}, socket) do
    save_goal(socket, socket.assigns.live_action, goal_params)
  end

  defp save_goal(socket, :edit, goal_params) do
    case Training.update_goal(socket.assigns.current_scope, socket.assigns.goal, goal_params) do
      {:ok, goal} ->
        {:noreply,
         socket
         |> put_flash(:info, "Goal updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, goal))}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_goal(socket, :new, goal_params) do
    case Training.create_goal(socket.assigns.current_scope, goal_params) do
      {:ok, goal} ->
        {:noreply,
         socket
         |> put_flash(:info, "Goal created successfully!")
         |> push_navigate(to: return_path(socket.assigns.return_to, goal))}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _goal), do: ~p"/goals"
  defp return_path("show", goal), do: ~p"/goals/#{goal}"
end
