defmodule SoccerTrackerWeb.TeamLive.Form do
  use SoccerTrackerWeb, :live_view
  alias SoccerTracker.Teams
  alias SoccerTracker.Teams.Team

  @impl true
  def mount(_params, _session, socket) do
    team = %Team{}
    {:ok, assign(socket, form: to_form(Teams.change_team(team)), team: team,
      page_title: "Create Team")}
  end

  @impl true
  def handle_event("validate", %{"team" => params}, socket) do
    cs = Teams.change_team(socket.assigns.team, params)
    {:noreply, assign(socket, form: to_form(cs, action: :validate))}
  end

  def handle_event("save", %{"team" => params}, socket) do
    case Teams.create_team(socket.assigns.current_scope, params) do
      {:ok, team} ->
        {:noreply, socket |> put_flash(:info, "Team created!") |> push_navigate(to: ~p"/teams/#{team.id}")}
      {:error, cs} ->
        {:noreply, assign(socket, form: to_form(cs))}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>Create a New Team</.header>
      <.form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Team Name" placeholder="e.g. FC Oshawa Warriors" />
        <.input field={@form[:description]} type="textarea" label="Description (optional)" />
        <footer>
          <.button variant="primary" phx-disable-with="Creating...">Create Team</.button>
          <.button navigate={~p"/teams"}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end
end
