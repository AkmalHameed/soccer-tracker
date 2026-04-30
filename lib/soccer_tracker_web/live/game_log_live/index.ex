defmodule SoccerTrackerWeb.GameLogLive.Index do
  use SoccerTrackerWeb, :live_view
  alias SoccerTracker.Training

  @impl true
  def mount(_params, _session, socket) do
    games = Training.list_game_logs(socket.assigns.current_scope)
    {:ok, assign(socket, page_title: "Match History") |> stream(:games, games)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    game = Training.get_game_log!(socket.assigns.current_scope, id)
    {:ok, _} = Training.delete_game_log(socket.assigns.current_scope, game)
    {:noreply, stream_delete(socket, :games, game)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <.header>
        ⚽ Match History
        <:actions>
          <.button variant="primary" navigate={~p"/games/new"}>
            <.icon name="hero-plus" /> Log Match
          </.button>
        </:actions>
      </.header>

      <.table id="games" rows={@streams.games}
        row_click={fn {_id, g} -> JS.navigate(~p"/games/#{g}") end}>
        <:col :let={{_id, g}} label="Date">{g.date}</:col>
        <:col :let={{_id, g}} label="Opponent">{g.opponent || "—"}</:col>
        <:col :let={{_id, g}} label="Score">
          {if g.our_score != nil, do: "#{g.our_score} — #{g.opponent_score}", else: "—"}
        </:col>
        <:col :let={{_id, g}} label="Result">
          <span class={"badge #{result_badge(g.result)}"}>{String.capitalize(g.result || "")}</span>
        </:col>
        <:col :let={{_id, g}} label="G/A">{g.goals}g / {g.assists}a</:col>
        <:col :let={{_id, g}} label="Rating">
          <%= if g.rating, do: "#{g.rating}/10", else: "—" %>
        </:col>
        <:action :let={{_id, g}}>
          <.link navigate={~p"/games/#{g}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, g}}>
          <.link phx-click={JS.push("delete", value: %{id: g.id}) |> hide("##{id}")}
            data-confirm="Delete this match?">Delete</.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  defp result_badge("win"), do: "badge-success"
  defp result_badge("loss"), do: "badge-error"
  defp result_badge("draw"), do: "badge-warning"
  defp result_badge(_), do: "badge-ghost"
end
