defmodule SoccerTrackerWeb.TeamLive.Index do
  use SoccerTrackerWeb, :live_view
  alias SoccerTracker.Teams

  @impl true
  def mount(_params, _session, socket) do
    {owned, member} = Teams.list_my_teams(socket.assigns.current_scope)
    {:ok, assign(socket, owned_teams: owned, member_teams: member, page_title: "My Teams")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="space-y-8">
        <div class="flex items-center justify-between">
          <h1 class="text-3xl font-bold">👥 My Teams</h1>
          <.button variant="primary" navigate={~p"/teams/new"}>
            <.icon name="hero-plus" /> Create Team
          </.button>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <h2 class="text-lg font-semibold mb-3 opacity-70">Teams I Manage</h2>
            <%= if @owned_teams == [] do %>
              <div class="card bg-base-200 p-6 text-center opacity-60">
                No teams yet. <.link navigate={~p"/teams/new"} class="link link-primary">Create one!</.link>
              </div>
            <% else %>
              <%= for team <- @owned_teams do %>
                <.link navigate={~p"/teams/#{team.id}"} class="card bg-base-200 hover:bg-base-300 transition-colors mb-3 block">
                  <div class="card-body py-4">
                    <div class="flex items-center justify-between">
                      <div>
                        <h3 class="font-bold text-lg">{team.name}</h3>
                        <p class="text-sm opacity-60">{length(team.members)} member(s) · You manage this</p>
                      </div>
                      <span class="badge badge-primary">Coach</span>
                    </div>
                  </div>
                </.link>
              <% end %>
            <% end %>
          </div>

          <div>
            <h2 class="text-lg font-semibold mb-3 opacity-70">Teams I'm On</h2>
            <%= if @member_teams == [] do %>
              <div class="card bg-base-200 p-6 text-center opacity-60">
                Not a member of any other teams yet.
              </div>
            <% else %>
              <%= for team <- @member_teams do %>
                <.link navigate={~p"/teams/#{team.id}"} class="card bg-base-200 hover:bg-base-300 transition-colors mb-3 block">
                  <div class="card-body py-4">
                    <div class="flex items-center justify-between">
                      <div>
                        <h3 class="font-bold text-lg">{team.name}</h3>
                        <p class="text-sm opacity-60">{length(team.members)} member(s)</p>
                      </div>
                      <span class="badge badge-secondary">Player</span>
                    </div>
                  </div>
                </.link>
              <% end %>
            <% end %>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
