defmodule SoccerTrackerWeb.TeamLive.Show do
  use SoccerTrackerWeb, :live_view
  alias SoccerTracker.Teams

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    team = Teams.get_team_for_user!(socket.assigns.current_scope, id)
    stats = Teams.team_stats(team.id)
    is_coach = Teams.is_coach?(socket.assigns.current_scope, team)
    {:ok, assign(socket, team: team, stats: stats, is_coach: is_coach,
      page_title: team.name, invite_email: "", invite_role: "player")}
  end

  @impl true
  def handle_event("invite", %{"email" => email, "role" => role}, socket) do
    case Teams.create_invite(socket.assigns.team.id, %{email: email, role: role}) do
      {:ok, invite} ->
        {:noreply, socket
          |> put_flash(:info, "Invite link generated! Share: /teams/join/#{invite.token}")
          |> assign(invite_token: invite.token)}
      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Failed to create invite.")}
    end
  end

  def handle_event("delete_team", _params, socket) do
    Teams.delete_team(socket.assigns.team)
    {:noreply, socket |> put_flash(:info, "Team deleted.") |> push_navigate(to: ~p"/teams")}
  end

  def handle_event("remove_member", %{"user_id" => user_id}, socket) do
    Teams.remove_member(socket.assigns.team.id, String.to_integer(user_id))
    team = Teams.get_team!(socket.assigns.team.id)
    {:noreply, assign(socket, team: team)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="space-y-8">
        <div class="flex items-center justify-between">
          <div>
            <.button navigate={~p"/teams"} class="mb-2">
              <.icon name="hero-arrow-left" /> Back
            </.button>
            <h1 class="text-3xl font-bold">{@team.name}</h1>
            <p class="opacity-60">{@team.description}</p>
          </div>
          <%= if @is_coach do %>
            <button phx-click="delete_team" data-confirm="Are you sure?" class="btn btn-error btn-sm">Delete Team</button>
          <% end %>
        </div>

        <%!-- Stats Row --%>
        <div class="grid grid-cols-2 md:grid-cols-5 gap-4">
          <%= for {label, val} <- [{"Played", @stats.played}, {"Wins", @stats.wins},
              {"Losses", @stats.losses}, {"Draws", @stats.draws}, {"Goals", @stats.goals}] do %>
            <div class="card bg-base-200 shadow text-center py-4">
              <p class="text-3xl font-bold text-primary">{val}</p>
              <p class="text-xs opacity-60 mt-1">{label}</p>
            </div>
          <% end %>
        </div>

        <%!-- Members --%>
        <div class="card bg-base-200 shadow-xl">
          <div class="card-body">
            <h2 class="card-title">👤 Squad ({length(@team.members)} players)</h2>
            <div class="overflow-x-auto">
              <table class="table table-zebra">
                <thead><tr><th>Player</th><th>Role</th><th>Position</th><th>#</th>
                  <%= if @is_coach do %><th></th><% end %>
                </tr></thead>
                <tbody>
                  <%= for m <- @team.members do %>
                    <tr>
                      <td>{m.user.email}</td>
                      <td><span class={"badge #{if m.role == "coach", do: "badge-primary", else: "badge-ghost"}"}>{m.role}</span></td>
                      <td>{m.position || "—"}</td>
                      <td>{m.jersey_number || "—"}</td>
                      <%= if @is_coach and m.user_id != @team.owner_id do %>
                        <td>
                          <button phx-click="remove_member" phx-value-user_id={m.user_id}
                            class="btn btn-xs btn-error btn-ghost"
                            data-confirm="Remove this player?">Remove</button>
                        </td>
                      <% end %>
                    </tr>
                  <% end %>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <%!-- Invite (coach only) --%>
        <%= if @is_coach do %>
          <div class="card bg-base-200 shadow-xl">
            <div class="card-body">
              <h2 class="card-title">✉️ Invite a Player</h2>
              <form phx-submit="invite" class="flex gap-3 flex-wrap items-end">
                <div class="form-control">
                  <label class="label"><span class="label-text">Email</span></label>
                  <input type="email" name="email" class="input input-bordered" placeholder="player@example.com" required />
                </div>
                <div class="form-control">
                  <label class="label"><span class="label-text">Role</span></label>
                  <select name="role" class="select select-bordered">
                    <option value="player">Player</option>
                    <option value="coach">Coach</option>
                  </select>
                </div>
                <button type="submit" class="btn btn-primary">Generate Invite Link</button>
              </form>
              <%= if assigns[:invite_token] do %>
                <div class="alert alert-success mt-3">
                  <span>Share this link: <strong>/teams/join/{@invite_token}</strong></span>
                </div>
              <% end %>
            </div>
          </div>
        <% end %>
      </div>
    </Layouts.app>
    """
  end
end
