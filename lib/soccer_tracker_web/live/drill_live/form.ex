defmodule SoccerTrackerWeb.DrillLive.Form do
  use SoccerTrackerWeb, :live_view

  alias SoccerTracker.Training
  alias SoccerTracker.Training.Drill

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Record a drill from your training session.</:subtitle>
      </.header>

      <.form for={@form} id="drill-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Drill Name" placeholder="e.g. Passing triangles" />
        <.input
          field={@form[:session_id]}
          type="select"
          label="Session"
          options={@session_options}
          prompt="Select a session..."
        />
        <.input field={@form[:sets]} type="number" label="Sets" min="1" />
        <.input field={@form[:reps]} type="number" label="Reps" min="1" />
        <.input field={@form[:duration]} type="number" label="Duration (minutes)" min="1" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Drill</.button>
          <.button navigate={return_path(@return_to, @drill)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    sessions = Training.list_sessions(socket.assigns.current_scope)
    session_options = Enum.map(sessions, fn s -> {"#{s.date} — #{s.type}", s.id} end)

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(:session_options, session_options)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    drill = Training.get_drill!(socket.assigns.current_scope, id)
    socket
    |> assign(:page_title, "Edit Drill")
    |> assign(:drill, drill)
    |> assign(:form, to_form(Training.change_drill(drill)))
  end

  defp apply_action(socket, :new, _params) do
    drill = %Drill{}
    socket
    |> assign(:page_title, "New Drill")
    |> assign(:drill, drill)
    |> assign(:form, to_form(Training.change_drill(drill)))
  end

  @impl true
  def handle_event("validate", %{"drill" => drill_params}, socket) do
    changeset = Training.change_drill(socket.assigns.drill, drill_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"drill" => drill_params}, socket) do
    save_drill(socket, socket.assigns.live_action, drill_params)
  end

  defp save_drill(socket, :edit, drill_params) do
    case Training.update_drill(socket.assigns.current_scope, socket.assigns.drill, drill_params) do
      {:ok, drill} ->
        {:noreply,
         socket
         |> put_flash(:info, "Drill updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, drill))}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_drill(socket, :new, drill_params) do
    case Training.create_drill(socket.assigns.current_scope, drill_params) do
      {:ok, drill} ->
        {:noreply,
         socket
         |> put_flash(:info, "Drill added successfully!")
         |> push_navigate(to: return_path(socket.assigns.return_to, drill))}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _drill), do: ~p"/drills"
  defp return_path("show", drill), do: ~p"/drills/#{drill}"
end
