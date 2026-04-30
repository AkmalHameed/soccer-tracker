defmodule SoccerTrackerWeb.GameLogLive.Show do
  use SoccerTrackerWeb, :live_view
  alias SoccerTracker.Training

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    game = Training.get_game_log!(socket.assigns.current_scope, id)
    {:ok, assign(socket, game: game, page_title: "Match vs #{game.opponent || "Unknown"}")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <.header>
        Match vs {@game.opponent || "Unknown Opponent"}
        <:subtitle>{@game.date}</:subtitle>
        <:actions>
          <.button navigate={~p"/games"}>← Back</.button>
          <.button variant="primary" navigate={~p"/games/#{@game}/edit"}>Edit</.button>
        </:actions>
      </.header>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mt-6">
        <div class="card bg-base-200 shadow">
          <div class="card-body">
            <h2 class="card-title">📊 Match Info</h2>
            <.list>
              <:item title="Result">
                <span class={"badge text-base #{result_badge(@game.result)}"}>{String.capitalize(@game.result || "")}</span>
              </:item>
              <:item title="Score">{@game.our_score} — {@game.opponent_score}</:item>
              <:item title="Location">{@game.location || "—"}</:item>
              <:item title="Team">{if @game.team, do: @game.team.name, else: "—"}</:item>
              <:item title="Minutes Played">{@game.minutes_played || "—"}</:item>
              <:item title="Position">{@game.position_played || "—"}</:item>
            </.list>
          </div>
        </div>

        <div class="card bg-base-200 shadow">
          <div class="card-body">
            <h2 class="card-title">⚽ My Stats</h2>
            <div class="grid grid-cols-3 gap-4 text-center mt-2">
              <%= for {label, val} <- [{"Goals", @game.goals}, {"Assists", @game.assists},
                  {"Shots", @game.shots}, {"On Target", @game.shots_on_target},
                  {"Saves", @game.saves}, {"Rating", "#{@game.rating || "—"}/10"}] do %>
                <div class="bg-base-300 rounded-lg p-3">
                  <p class="text-2xl font-bold text-primary">{val}</p>
                  <p class="text-xs opacity-60">{label}</p>
                </div>
              <% end %>
            </div>
          </div>
        </div>
      </div>

      <%= if @game.notes do %>
        <div class="card bg-base-200 shadow mt-4">
          <div class="card-body">
            <h2 class="card-title">📝 Notes</h2>
            <p>{@game.notes}</p>
          </div>
        </div>
      <% end %>
    </Layouts.app>
    """
  end

  defp result_badge("win"), do: "badge-success"
  defp result_badge("loss"), do: "badge-error"
  defp result_badge("draw"), do: "badge-warning"
  defp result_badge(_), do: "badge-ghost"
end
