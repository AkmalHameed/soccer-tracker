defmodule SoccerTrackerWeb.ProgramLive.Index do
  use SoccerTrackerWeb, :live_view
  alias SoccerTracker.Programs

  @impl true
  def mount(_params, _session, socket) do
    all_programs = Programs.list_programs()
    my_programs = Programs.list_my_programs(socket.assigns.current_scope)
    my_program_ids = Enum.map(my_programs, & &1.program_id)
    {:ok, assign(socket, all_programs: all_programs, my_programs: my_programs,
      my_program_ids: my_program_ids, page_title: "Training Programs")}
  end

  @impl true
  def handle_event("enroll", %{"id" => id}, socket) do
    case Programs.enroll(socket.assigns.current_scope, String.to_integer(id)) do
      {:ok, _} ->
        my_programs = Programs.list_my_programs(socket.assigns.current_scope)
        my_program_ids = Enum.map(my_programs, & &1.program_id)
        {:noreply, socket |> put_flash(:info, "Enrolled! Program started.") |> assign(my_programs: my_programs, my_program_ids: my_program_ids)}
      _ ->
        {:noreply, put_flash(socket, :error, "Already enrolled.")}
    end
  end

  def handle_event("advance", %{"id" => id}, socket) do
    Programs.advance_week(socket.assigns.current_scope, String.to_integer(id))
    my_programs = Programs.list_my_programs(socket.assigns.current_scope)
    {:noreply, socket |> put_flash(:info, "Advanced to next week!") |> assign(my_programs: my_programs)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="space-y-8">
        <h1 class="text-3xl font-bold">📅 Training Programs</h1>

        <%= if @my_programs != [] do %>
          <div class="card bg-primary/10 border border-primary/20 shadow-xl">
            <div class="card-body">
              <h2 class="card-title text-primary">🏃 Active Programs</h2>
              <div class="space-y-3">
                <%= for up <- @my_programs do %>
                  <div class="bg-base-200 rounded-xl p-4 flex items-center justify-between">
                    <div>
                      <p class="font-bold">{up.program.name}</p>
                      <p class="text-sm opacity-60">Week {up.current_week} of {up.program.duration_weeks}</p>
                      <progress class="progress progress-primary w-48 mt-2"
                        value={up.current_week} max={up.program.duration_weeks} />
                    </div>
                    <button phx-click="advance" phx-value-id={up.program_id}
                      class="btn btn-sm btn-primary">✓ Complete Week</button>
                  </div>
                <% end %>
              </div>
            </div>
          </div>
        <% end %>

        <div>
          <h2 class="text-xl font-semibold mb-4">Available Programs</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
            <%= for program <- @all_programs do %>
              <div class="card bg-base-200 shadow-xl">
                <div class="card-body">
                  <div class="flex items-start justify-between">
                    <div>
                      <h3 class="card-title">{program.name}</h3>
                      <p class="text-sm opacity-70 mt-1">{program.description}</p>
                    </div>
                    <span class="text-3xl">{focus_icon(program.focus)}</span>
                  </div>
                  <div class="flex flex-wrap gap-2 mt-3">
                    <span class="badge badge-ghost">{String.capitalize(program.focus || "")}</span>
                    <span class={"badge #{diff_badge(program.difficulty)}"}>{String.capitalize(program.difficulty || "")}</span>
                    <span class="badge badge-ghost">📅 {program.duration_weeks} weeks</span>
                  </div>
                  <div class="card-actions justify-end mt-4">
                    <%= if program.id in @my_program_ids do %>
                      <span class="badge badge-success badge-lg">✓ Enrolled</span>
                    <% else %>
                      <button phx-click="enroll" phx-value-id={program.id}
                        class="btn btn-primary btn-sm">Start Program</button>
                    <% end %>
                  </div>
                </div>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  defp focus_icon("fitness"), do: "💪"
  defp focus_icon("technical"), do: "⚽"
  defp focus_icon("tactical"), do: "🧠"
  defp focus_icon("goalkeeping"), do: "🧤"
  defp focus_icon(_), do: "📋"

  defp diff_badge("beginner"), do: "badge-success"
  defp diff_badge("intermediate"), do: "badge-warning"
  defp diff_badge("advanced"), do: "badge-error"
  defp diff_badge(_), do: "badge-ghost"
end
