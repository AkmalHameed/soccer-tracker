defmodule SoccerTrackerWeb.TeamLive.Join do
  use SoccerTrackerWeb, :live_view
  alias SoccerTracker.Teams

  @impl true
  def mount(%{"token" => token}, _session, socket) do
    invite = Teams.get_invite_by_token(token)
    {:ok, assign(socket, invite: invite, token: token, page_title: "Join Team")}
  end

  @impl true
  def handle_event("accept", _params, socket) do
    user_id = socket.assigns.current_scope.user.id
    case Teams.accept_invite(socket.assigns.invite, user_id) do
      {:ok, _} ->
        team_id = socket.assigns.invite.team_id
        {:noreply, socket |> put_flash(:info, "Welcome to the team!") |> push_navigate(to: ~p"/teams/#{team_id}")}
      _ ->
        {:noreply, put_flash(socket, :error, "Failed to join team.")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="max-w-md mx-auto text-center space-y-6 mt-20">
        <%= if @invite do %>
          <div class="text-6xl">⚽</div>
          <h1 class="text-3xl font-bold">You're Invited!</h1>
          <p class="text-lg">Join <strong>{@invite.team.name}</strong> as a <strong>{@invite.role}</strong></p>
          <button phx-click="accept" class="btn btn-primary btn-lg w-full">Accept Invite</button>
        <% else %>
          <h1 class="text-3xl font-bold">Invalid Invite</h1>
          <p class="opacity-60">This invite link is expired or invalid.</p>
          <.button navigate={~p"/dashboard"}>Go Home</.button>
        <% end %>
      </div>
    </Layouts.app>
    """
  end
end
