defmodule SoccerTrackerWeb.GameLogLive.Form do
  use SoccerTrackerWeb, :live_view
  alias SoccerTracker.{Training, Teams}
  alias SoccerTracker.Training.GameLog

  @impl true
  def mount(params, _session, socket) do
    {owned, member} = Teams.list_my_teams(socket.assigns.current_scope)
    teams = owned ++ member
    team_options = [{"No Team", nil}] ++ Enum.map(teams, &{&1.name, &1.id})
    {:ok, socket
      |> assign(:return_to, params["return_to"] || "index")
      |> assign(:team_options, team_options)
      |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    game = %GameLog{}
    socket |> assign(page_title: "Log Match", game: game,
      form: to_form(Training.change_game_log(game)))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    game = Training.get_game_log!(socket.assigns.current_scope, id)
    socket |> assign(page_title: "Edit Match", game: game,
      form: to_form(Training.change_game_log(game)))
  end

  @impl true
  def handle_event("validate", %{"game_log" => params}, socket) do
    cs = Training.change_game_log(socket.assigns.game, params)
    {:noreply, assign(socket, form: to_form(cs, action: :validate))}
  end

  def handle_event("save", %{"game_log" => params}, socket) do
    case socket.assigns.live_action do
      :new ->
        case Training.create_game_log(socket.assigns.current_scope, params) do
          {:ok, game} -> {:noreply, socket |> put_flash(:info, "Match logged!") |> push_navigate(to: ~p"/games/#{game}")}
          {:error, cs} -> {:noreply, assign(socket, form: to_form(cs))}
        end
      :edit ->
        case Training.update_game_log(socket.assigns.current_scope, socket.assigns.game, params) do
          {:ok, game} -> {:noreply, socket |> put_flash(:info, "Match updated!") |> push_navigate(to: ~p"/games/#{game}")}
          {:error, cs} -> {:noreply, assign(socket, form: to_form(cs))}
        end
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>{@page_title}</.header>
      <.form for={@form} phx-change="validate" phx-submit="save">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-x-6">
          <.input field={@form[:date]} type="date" label="Match Date" />
          <.input field={@form[:opponent]} type="text" label="Opponent" placeholder="e.g. FC Rivals" />
          <.input field={@form[:location]} type="text" label="Location" placeholder="e.g. Home / Away" />
          <.input field={@form[:result]} type="select" label="Result"
            options={[{"Win", "win"}, {"Loss", "loss"}, {"Draw", "draw"}]} prompt="Select result..." />
          <.input field={@form[:our_score]} type="number" label="Our Score" min="0" />
          <.input field={@form[:opponent_score]} type="number" label="Their Score" min="0" />
          <.input field={@form[:position_played]} type="select" label="Position Played"
            options={GameLog.positions()} prompt="Select position..." />
          <.input field={@form[:minutes_played]} type="number" label="Minutes Played" min="1" max="120" />
          <.input field={@form[:goals]} type="number" label="Goals" min="0" />
          <.input field={@form[:assists]} type="number" label="Assists" min="0" />
          <.input field={@form[:shots]} type="number" label="Shots" min="0" />
          <.input field={@form[:shots_on_target]} type="number" label="Shots on Target" min="0" />
          <.input field={@form[:saves]} type="number" label="Saves (GK)" min="0" />
          <.input field={@form[:rating]} type="number" label="Self Rating (1-10)" min="1" max="10" />
          <.input field={@form[:team_id]} type="select" label="Team"
            options={@team_options} />
        </div>
        <.input field={@form[:notes]} type="textarea" label="Match Notes" />
        <footer>
          <.button variant="primary" phx-disable-with="Saving...">Save Match</.button>
          <.button navigate={~p"/games"}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end
end
