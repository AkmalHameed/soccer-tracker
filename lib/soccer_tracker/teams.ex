defmodule SoccerTracker.Teams do
  import Ecto.Query, warn: false
  alias SoccerTracker.Repo
  alias SoccerTracker.Accounts.Scope
  alias SoccerTracker.Teams.{Team, TeamMember, TeamInvite}

  # ---- Teams ----

  def list_my_teams(%Scope{user: user}) do
    owned = Repo.all(from t in Team, where: t.owner_id == ^user.id, preload: [:members])
    member_team_ids =
      Repo.all(from m in TeamMember, where: m.user_id == ^user.id, select: m.team_id)
    member_teams =
      Repo.all(from t in Team, where: t.id in ^member_team_ids and t.owner_id != ^user.id,
        preload: [:members])
    {owned, member_teams}
  end

  def get_team!(id), do: Repo.get!(Team, id) |> Repo.preload(members: :user)

  def get_team_for_user!(%Scope{user: user}, id) do
    team = get_team!(id)
    is_member = Enum.any?(team.members, &(&1.user_id == user.id))
    is_owner = team.owner_id == user.id
    if is_owner or is_member do
      team
    else
      raise Ecto.NoResultsError, queryable: Team
    end
  end

  def create_team(%Scope{user: user}, attrs) do
    Repo.transaction(fn ->
      team = %Team{owner_id: user.id}
        |> Team.changeset(attrs)
        |> Repo.insert!()
      %TeamMember{team_id: team.id, user_id: user.id, role: "coach",
        joined_at: DateTime.utc_now(:second)}
        |> Repo.insert!()
      team
    end)
  end

  def update_team(%Team{} = team, attrs) do
    team |> Team.changeset(attrs) |> Repo.update()
  end

  def delete_team(%Team{} = team), do: Repo.delete(team)

  def change_team(%Team{} = team, attrs \\ %{}), do: Team.changeset(team, attrs)

  # ---- Members ----

  def list_members(team_id) do
    Repo.all(from m in TeamMember, where: m.team_id == ^team_id, preload: :user)
  end

  def add_member(team_id, user_id, role \\ "player") do
    %TeamMember{team_id: team_id, user_id: user_id, role: role,
      joined_at: DateTime.utc_now(:second)}
    |> Repo.insert(on_conflict: :nothing)
  end

  def remove_member(team_id, user_id) do
    Repo.delete_all(from m in TeamMember,
      where: m.team_id == ^team_id and m.user_id == ^user_id)
  end

  def is_coach?(%Scope{user: user}, team) do
    team.owner_id == user.id or
      Enum.any?(team.members, &(&1.user_id == user.id and &1.role == "coach"))
  end

  # ---- Invites ----

  def create_invite(team_id, attrs) do
    token = :crypto.strong_rand_bytes(16) |> Base.url_encode64(padding: false)
    expires_at = DateTime.add(DateTime.utc_now(:second), 7 * 24 * 3600, :second)
    %TeamInvite{team_id: team_id, token: token, expires_at: expires_at}
    |> TeamInvite.changeset(attrs)
    |> Repo.insert()
  end

  def get_invite_by_token(token) do
    Repo.get_by(TeamInvite, token: token) |> Repo.preload(:team)
  end

  def accept_invite(invite, user_id) do
    Repo.transaction(fn ->
      add_member(invite.team_id, user_id, invite.role)
      invite
      |> Ecto.Changeset.change(accepted_at: DateTime.utc_now(:second))
      |> Repo.update!()
    end)
  end

  # ---- Team Stats ----

  def team_stats(team_id) do
    alias SoccerTracker.Training.GameLog
    games = Repo.all(from g in GameLog, where: g.team_id == ^team_id)
    wins = Enum.count(games, &(&1.result == "win"))
    losses = Enum.count(games, &(&1.result == "loss"))
    draws = Enum.count(games, &(&1.result == "draw"))
    goals = Enum.sum(Enum.map(games, &(&1.goals || 0)))
    %{played: length(games), wins: wins, losses: losses, draws: draws, goals: goals}
  end
end
