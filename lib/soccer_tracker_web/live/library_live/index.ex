defmodule SoccerTrackerWeb.LibraryLive.Index do
  use SoccerTrackerWeb, :live_view
  alias SoccerTracker.Library
  alias SoccerTracker.Library.DrillTemplate

  @impl true
  def mount(_params, _session, socket) do
    drills = Library.list_drill_templates()
    counts = Library.categories_with_counts()
    {:ok, assign(socket, drills: drills, counts: counts,
      filter_category: "", filter_difficulty: "", search: "",
      page_title: "Drill Library", selected_drill: nil)}
  end

  @impl true
  def handle_event("filter", params, socket) do
    filters = %{
      category: params["category"] || "",
      difficulty: params["difficulty"] || "",
      search: params["search"] || ""
    }
    drills = Library.list_drill_templates(filters)
    {:noreply, assign(socket, drills: drills,
      filter_category: filters.category,
      filter_difficulty: filters.difficulty,
      search: filters.search)}
  end

  def handle_event("show_drill", %{"id" => id}, socket) do
    drill = Library.get_drill_template!(String.to_integer(id))
    {:noreply, assign(socket, selected_drill: drill)}
  end

  def handle_event("close_drill", _params, socket) do
    {:noreply, assign(socket, selected_drill: nil)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="space-y-6">
        <div class="flex items-center justify-between">
          <h1 class="text-3xl font-bold">📚 Drill Library</h1>
          <span class="badge badge-primary badge-lg">{length(@drills)} drills</span>
        </div>

        <%!-- Filters --%>
        <form phx-change="filter" class="flex flex-wrap gap-3 items-end">
          <input type="text" name="search" value={@search} placeholder="Search drills..."
            class="input input-bordered input-sm flex-1 min-w-48" />
          <select name="category" class="select select-bordered select-sm">
            <option value="">All Categories</option>
            <%= for cat <- DrillTemplate.categories() do %>
              <option value={cat} selected={@filter_category == cat}>
                {String.capitalize(cat)} ({Map.get(@counts, cat, 0)})
              </option>
            <% end %>
          </select>
          <select name="difficulty" class="select select-bordered select-sm">
            <option value="">All Levels</option>
            <%= for d <- DrillTemplate.difficulties() do %>
              <option value={d} selected={@filter_difficulty == d}>{String.capitalize(d)}</option>
            <% end %>
          </select>
        </form>

        <%!-- Category icons map --%>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          <%= for drill <- @drills do %>
            <div class="card bg-base-200 hover:bg-base-300 cursor-pointer transition-all shadow"
              phx-click="show_drill" phx-value-id={drill.id}>
              <div class="card-body py-4">
                <div class="flex items-start justify-between">
                  <div>
                    <h3 class="font-bold">{drill.name}</h3>
                    <p class="text-sm opacity-70 mt-1">{drill.description |> String.slice(0, 80)}...</p>
                  </div>
                  <span class="text-2xl ml-2">{category_icon(drill.category)}</span>
                </div>
                <div class="flex flex-wrap gap-2 mt-3">
                  <span class="badge badge-ghost badge-sm">{String.capitalize(drill.category)}</span>
                  <span class={"badge badge-sm #{difficulty_badge(drill.difficulty)}"}>{String.capitalize(drill.difficulty)}</span>
                  <%= if drill.duration_minutes do %>
                    <span class="badge badge-ghost badge-sm">⏱ {drill.duration_minutes}min</span>
                  <% end %>
                  <%= if drill.players_needed do %>
                    <span class="badge badge-ghost badge-sm">👥 {drill.players_needed}+</span>
                  <% end %>
                </div>
              </div>
            </div>
          <% end %>
        </div>

        <%!-- Drill Detail Modal --%>
        <%= if @selected_drill do %>
          <div class="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4"
            phx-click="close_drill">
            <div class="card bg-base-100 max-w-2xl w-full max-h-[90vh] overflow-y-auto shadow-2xl"
              phx-click-away="close_drill">
              <div class="card-body">
                <div class="flex items-start justify-between">
                  <div>
                    <h2 class="card-title text-2xl">
                      {category_icon(@selected_drill.category)} {@selected_drill.name}
                    </h2>
                    <div class="flex gap-2 mt-2">
                      <span class="badge badge-ghost">{String.capitalize(@selected_drill.category)}</span>
                      <span class={"badge #{difficulty_badge(@selected_drill.difficulty)}"}>{String.capitalize(@selected_drill.difficulty)}</span>
                      <%= if @selected_drill.duration_minutes do %>
                        <span class="badge badge-ghost">⏱ {@selected_drill.duration_minutes} min</span>
                      <% end %>
                      <%= if @selected_drill.players_needed do %>
                        <span class="badge badge-ghost">👥 {@selected_drill.players_needed}+ players</span>
                      <% end %>
                    </div>
                  </div>
                  <button phx-click="close_drill" class="btn btn-ghost btn-sm btn-circle">✕</button>
                </div>

                <p class="mt-4">{@selected_drill.description}</p>

                <%= if @selected_drill.equipment do %>
                  <div class="mt-4">
                    <h3 class="font-semibold mb-1">🎒 Equipment</h3>
                    <p class="text-sm opacity-80">{@selected_drill.equipment}</p>
                  </div>
                <% end %>

                <%= if @selected_drill.instructions do %>
                  <div class="mt-4">
                    <h3 class="font-semibold mb-2">📋 Instructions</h3>
                    <div class="bg-base-200 rounded-lg p-4 text-sm whitespace-pre-line">
                      {@selected_drill.instructions}
                    </div>
                  </div>
                <% end %>

                <%= if @selected_drill.tips do %>
                  <div class="mt-4">
                    <h3 class="font-semibold mb-1">💡 Coaching Tips</h3>
                    <p class="text-sm opacity-80">{@selected_drill.tips}</p>
                  </div>
                <% end %>

                <div class="card-actions justify-end mt-4">
                  <button phx-click="close_drill" class="btn btn-ghost">Close</button>
                </div>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </Layouts.app>
    """
  end

  defp category_icon("passing"), do: "🔄"
  defp category_icon("shooting"), do: "🎯"
  defp category_icon("dribbling"), do: "🏃"
  defp category_icon("fitness"), do: "💪"
  defp category_icon("defending"), do: "🛡️"
  defp category_icon("goalkeeping"), do: "🧤"
  defp category_icon(_), do: "⚽"

  defp difficulty_badge("beginner"), do: "badge-success"
  defp difficulty_badge("intermediate"), do: "badge-warning"
  defp difficulty_badge("advanced"), do: "badge-error"
  defp difficulty_badge(_), do: "badge-ghost"
end
