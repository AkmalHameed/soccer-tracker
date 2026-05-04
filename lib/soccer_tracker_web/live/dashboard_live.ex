defmodule SoccerTrackerWeb.DashboardLive do
  use SoccerTrackerWeb, :live_view
  alias SoccerTracker.Training

  def mount(_params, _session, socket) do
    scope = socket.assigns.current_scope
    stats = Training.player_stats(scope)
    insights = Training.generate_insights(scope)
    form = Training.recent_form(scope, 5)
    goals = Training.list_goals(scope)
    monthly = Training.monthly_session_counts(scope)
    monthly_data = Enum.map(monthly, fn {dt, count} ->
      month = Calendar.strftime(dt, "%b %Y")
      %{month: month, count: count}
    end)

    {:ok, assign(socket,
      stats: stats,
      insights: insights,
      recent_form: form,
      goals: goals,
      monthly_data: monthly_data,
      page_title: "Dashboard"
    )}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="space-y-8">

        <%!-- Header --%>
        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-4xl font-bold">⚽ Dashboard</h1>
            <p class="text-base-content/60 mt-1">Your soccer performance at a glance</p>
          </div>
          <div class="flex gap-2">
            <a href={~p"/games/new"} class="btn btn-outline btn-sm">+ Match</a>
            <a href={~p"/sessions/new"} class="btn btn-primary btn-sm">+ Session</a>
          </div>
        </div>

        <%!-- AI Insights --%>
        <%= if @insights != [] do %>
          <div class="card bg-gradient-to-r from-primary/10 to-secondary/10 border border-primary/20 shadow-xl">
            <div class="card-body">
              <h2 class="card-title text-primary">🤖 Coaching Insights</h2>
              <div class="space-y-2">
                <%= for insight <- @insights do %>
                  <div class="bg-base-100/50 rounded-lg px-4 py-2 text-sm">{insight}</div>
                <% end %>
              </div>
            </div>
          </div>
        <% end %>

        <%!-- Career Stats --%>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
          <%= for {icon, label, val} <- [
            {"🏃", "Sessions", @stats.sessions},
            {"⚽", "Goals", @stats.goals},
            {"🎯", "Assists", @stats.assists},
            {"📍", "Km Covered", @stats.total_distance}
          ] do %>
            <div class="card bg-base-200 shadow-xl">
              <div class="card-body items-center text-center py-5">
                <div class="text-3xl">{icon}</div>
                <p class="text-4xl font-bold text-primary">{val}</p>
                <p class="text-xs opacity-60">{label}</p>
              </div>
            </div>
          <% end %>
        </div>

        <%!-- Match Record --%>
        <div class="card bg-base-200 shadow-xl">
          <div class="card-body">
            <div class="flex items-center justify-between mb-2">
              <h2 class="card-title">🏟️ Match Record</h2>
              <a href={~p"/games"} class="btn btn-ghost btn-sm">View All →</a>
            </div>
            <div class="flex gap-6 items-center flex-wrap">
              <div class="text-center">
                <p class="text-4xl font-bold text-success">{@stats.wins}</p>
                <p class="text-xs opacity-60">Wins</p>
              </div>
              <div class="text-center">
                <p class="text-4xl font-bold text-error">{@stats.losses}</p>
                <p class="text-xs opacity-60">Losses</p>
              </div>
              <div class="text-center">
                <p class="text-4xl font-bold text-warning">{@stats.draws}</p>
                <p class="text-xs opacity-60">Draws</p>
              </div>
              <div class="flex-1 min-w-40">
                <%= if @stats.games > 0 do %>
                  <div class="text-sm opacity-60 mb-1">Win Rate: {@stats.win_rate}%</div>
                  <div class="w-full h-4 bg-base-300 rounded-full overflow-hidden flex">
                    <div class="bg-success h-full transition-all" style={"width: #{@stats.win_rate}%"}></div>
                    <div class="bg-warning h-full transition-all"
                      style={"width: #{if @stats.games > 0, do: Float.round(@stats.draws / @stats.games * 100, 1), else: 0}%"}></div>
                  </div>
                <% else %>
                  <p class="text-sm opacity-40">No matches logged yet</p>
                <% end %>
              </div>
            </div>

            <%!-- Recent Form --%>
            <%= if @recent_form != [] do %>
              <div class="mt-4">
                <p class="text-sm font-semibold opacity-70 mb-2">Recent Form</p>
                <div class="flex gap-2">
                  <%= for game <- @recent_form do %>
                    <div class={"w-10 h-10 rounded-full flex items-center justify-center font-bold text-sm #{form_pill(game.result)}"}>
                      {String.upcase(String.first(game.result))}
                    </div>
                  <% end %>
                </div>
              </div>
            <% end %>
          </div>
        </div>

        <%!-- Monthly Activity Chart (CSS bars) --%>
        <%= if @monthly_data != [] do %>
          <div class="card bg-base-200 shadow-xl">
            <div class="card-body">
              <h2 class="card-title">📈 Monthly Sessions</h2>
              <div class="flex items-end gap-2 mt-4" style="height: 80px;">
                <% max_count = Enum.max_by(@monthly_data, & &1.count).count %>
                <%= for item <- @monthly_data do %>
                  <div class="flex flex-col items-center flex-1 gap-1">
                    <span class="text-xs font-bold text-primary">{item.count}</span>
                    <div class="w-full bg-primary rounded-t transition-all"
                      style={"height: #{if max_count > 0, do: max(round(item.count / max_count * 48), 6), else: 4}px; max-height: 48px;"}></div>
                    <span class="text-xs opacity-50 -rotate-45 origin-top-left whitespace-nowrap">
                      {item.month |> String.split(" ") |> List.first()}
                    </span>
                  </div>
                <% end %>
              </div>
            </div>
          </div>
        <% end %>

        <%!-- Goals Progress --%>
        <div class="card bg-base-200 shadow-xl">
          <div class="card-body">
            <div class="flex items-center justify-between mb-4">
              <h2 class="card-title">🎯 Training Goals</h2>
              <div class="flex gap-2">
                <a href={~p"/goals/new"} class="btn btn-ghost btn-sm">+ Add</a>
                <a href={~p"/goals"} class="btn btn-ghost btn-sm">View All →</a>
              </div>
            </div>
            <%= if @goals == [] do %>
              <div class="text-center opacity-60 py-6">
                No goals yet. <a href={~p"/goals/new"} class="link link-primary">Set your first goal!</a>
              </div>
            <% else %>
              <div class="space-y-3">
                <%= for goal <- Enum.take(@goals, 4) do %>
                  <div class="bg-base-300 rounded-xl p-3">
                    <div class="flex justify-between items-center mb-1">
                      <span class="font-medium">{goal.type}</span>
                      <span class="text-sm opacity-60">{goal.current_value} / {goal.target}</span>
                    </div>
                    <progress class="progress progress-primary w-full h-2"
                      value={goal.current_value} max={goal.target} />
                    <p class="text-xs opacity-40 mt-1">Deadline: {goal.deadline}</p>
                  </div>
                <% end %>
              </div>
            <% end %>
          </div>
        </div>

        <%!-- Quick Links --%>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
          <%= for {icon, label, href} <- [
            {"📚", "Drill Library", ~p"/library"},
            {"📅", "Programs", ~p"/programs"},
            {"👥", "My Teams", ~p"/teams"},
            {"📋", "Sessions", ~p"/sessions"}
          ] do %>
            <a href={href} class="card bg-base-200 hover:bg-base-300 transition-colors shadow cursor-pointer">
              <div class="card-body items-center text-center py-5">
                <div class="text-3xl">{icon}</div>
                <p class="text-sm font-medium mt-1">{label}</p>
              </div>
            </a>
          <% end %>
        </div>

      </div>
    </Layouts.app>
    """
  end

  defp form_pill("win"), do: "bg-success text-success-content"
  defp form_pill("loss"), do: "bg-error text-error-content"
  defp form_pill("draw"), do: "bg-warning text-warning-content"
  defp form_pill(_), do: "bg-base-300"
end
