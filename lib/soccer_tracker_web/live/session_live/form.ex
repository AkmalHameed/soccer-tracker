defmodule SoccerTrackerWeb.SessionLive.Form do
  use SoccerTrackerWeb, :live_view

  alias SoccerTracker.Training
  alias SoccerTracker.Training.Session

  @session_types ~w(Training Match Fitness Friendly Other)

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Log your soccer session details.</:subtitle>
      </.header>

      <.form for={@form} id="session-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:date]} type="date" label="Date" />
        <.input
          field={@form[:type]}
          type="select"
          label="Session Type"
          options={@session_types}
          prompt="Select a type..."
        />
        <.input field={@form[:duration]} type="number" label="Duration (minutes)" min="1" />
        <.input field={@form[:distance]} type="number" label="Distance (km)" step="0.1" min="0" />
        <.input field={@form[:notes]} type="textarea" label="Notes (optional)" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Session</.button>
          <.button navigate={return_path(@return_to, @session)}>Cancel</.button>
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
     |> assign(:session_types, @session_types)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    session = Training.get_session!(socket.assigns.current_scope, id)
    socket
    |> assign(:page_title, "Edit Session")
    |> assign(:session, session)
    |> assign(:form, to_form(Training.change_session(session)))
  end

  defp apply_action(socket, :new, _params) do
    session = %Session{}
    socket
    |> assign(:page_title, "Log New Session")
    |> assign(:session, session)
    |> assign(:form, to_form(Training.change_session(session)))
  end

  @impl true
  def handle_event("validate", %{"session" => session_params}, socket) do
    changeset = Training.change_session(socket.assigns.session, session_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"session" => session_params}, socket) do
    save_session(socket, socket.assigns.live_action, session_params)
  end

  defp save_session(socket, :edit, session_params) do
    case Training.update_session(socket.assigns.current_scope, socket.assigns.session, session_params) do
      {:ok, session} ->
        {:noreply,
         socket
         |> put_flash(:info, "Session updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, session))}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_session(socket, :new, session_params) do
    case Training.create_session(socket.assigns.current_scope, session_params) do
      {:ok, session} ->
        {:noreply,
         socket
         |> put_flash(:info, "Session logged successfully!")
         |> push_navigate(to: return_path(socket.assigns.return_to, session))}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _session), do: ~p"/sessions"
  defp return_path("show", session), do: ~p"/sessions/#{session}"
end
