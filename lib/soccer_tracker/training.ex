defmodule SoccerTracker.Training do
  import Ecto.Query, warn: false
  alias SoccerTracker.Repo
  alias SoccerTracker.Accounts.Scope

  alias SoccerTracker.Training.Session

  def list_sessions(%Scope{user: user}) do
    Repo.all(from s in Session, where: s.user_id == ^user.id, order_by: [desc: s.date])
  end

  def get_session!(%Scope{user: user}, id) do
    Repo.get_by!(Session, id: id, user_id: user.id)
  end

  def create_session(%Scope{user: user}, attrs) do
    %Session{user_id: user.id}
    |> Session.changeset(attrs)
    |> Repo.insert()
  end

  def update_session(%Scope{user: user}, %Session{user_id: uid} = session, attrs)
      when uid == user.id do
    session |> Session.changeset(attrs) |> Repo.update()
  end

  def delete_session(%Scope{user: user}, %Session{user_id: uid} = session)
      when uid == user.id do
    Repo.delete(session)
  end

  def change_session(%Session{} = session, attrs \\ %{}) do
    Session.changeset(session, attrs)
  end

  alias SoccerTracker.Training.Drill

  def list_drills(%Scope{user: user}) do
    Repo.all(
      from d in Drill,
        join: s in Session,
        on: d.session_id == s.id,
        where: s.user_id == ^user.id,
        order_by: [desc: d.inserted_at]
    )
  end

  def get_drill!(%Scope{user: user}, id) do
    drill = Repo.get!(Drill, id) |> Repo.preload(:session)
    if drill.session.user_id == user.id do
      drill
    else
      raise Ecto.NoResultsError, queryable: Drill
    end
  end

  def create_drill(%Scope{}, attrs) do
    %Drill{} |> Drill.changeset(attrs) |> Repo.insert()
  end

  def update_drill(%Scope{user: user}, %Drill{} = drill, attrs) do
    drill = Repo.preload(drill, :session)
    if drill.session.user_id != user.id do
      raise Ecto.NoResultsError, queryable: Drill
    end
    drill |> Drill.changeset(attrs) |> Repo.update()
  end

  def delete_drill(%Scope{user: user}, %Drill{} = drill) do
    drill = Repo.preload(drill, :session)
    if drill.session.user_id != user.id do
      raise Ecto.NoResultsError, queryable: Drill
    end
    Repo.delete(drill)
  end

  def change_drill(%Drill{} = drill, attrs \\ %{}) do
    Drill.changeset(drill, attrs)
  end

  alias SoccerTracker.Training.Goal

  def list_goals(%Scope{user: user}) do
    Repo.all(from g in Goal, where: g.user_id == ^user.id, order_by: [asc: g.deadline])
  end

  def get_goal!(%Scope{user: user}, id) do
    Repo.get_by!(Goal, id: id, user_id: user.id)
  end

  def create_goal(%Scope{user: user}, attrs) do
    %Goal{user_id: user.id} |> Goal.changeset(attrs) |> Repo.insert()
  end

  def update_goal(%Scope{user: user}, %Goal{user_id: uid} = goal, attrs)
      when uid == user.id do
    goal |> Goal.changeset(attrs) |> Repo.update()
  end

  def delete_goal(%Scope{user: user}, %Goal{user_id: uid} = goal)
      when uid == user.id do
    Repo.delete(goal)
  end

  def change_goal(%Goal{} = goal, attrs \\ %{}) do
    Goal.changeset(goal, attrs)
  end

  # ---- Game Logs ----

  alias SoccerTracker.Training.GameLog

  def list_game_logs(%Scope{user: user}) do
    Repo.all(from g in GameLog, where: g.user_id == ^user.id,
      order_by: [desc: g.date], preload: :team)
  end

  def get_game_log!(%Scope{user: user}, id) do
    Repo.get_by!(GameLog, id: id, user_id: user.id) |> Repo.preload(:team)
  end

  def create_game_log(%Scope{user: user}, attrs) do
    %GameLog{user_id: user.id} |> GameLog.changeset(attrs) |> Repo.insert()
  end

  def update_game_log(%Scope{user: user}, %GameLog{user_id: uid} = g, attrs)
      when uid == user.id do
    g |> GameLog.changeset(attrs) |> Repo.update()
  end

  def delete_game_log(%Scope{user: user}, %GameLog{user_id: uid} = g)
      when uid == user.id do
    Repo.delete(g)
  end

  def change_game_log(%GameLog{} = g, attrs \\ %{}) do
    GameLog.changeset(g, attrs)
  end

  # ---- Stats & Insights ----

  def player_stats(%Scope{user: user}) do
    sessions = Repo.all(from s in Session, where: s.user_id == ^user.id)
    games = Repo.all(from g in GameLog, where: g.user_id == ^user.id)
    goals_total = Enum.sum(Enum.map(games, &(&1.goals || 0)))
    assists_total = Enum.sum(Enum.map(games, &(&1.assists || 0)))
    wins = Enum.count(games, &(&1.result == "win"))
    losses = Enum.count(games, &(&1.result == "loss"))
    draws = Enum.count(games, &(&1.result == "draw"))
    total_distance = sessions |> Enum.map(&(&1.distance || 0)) |> Enum.sum()
    total_duration = sessions |> Enum.map(&(&1.duration || 0)) |> Enum.sum()
    rated = Enum.filter(games, &(&1.rating != nil))
    avg_rating =
      if rated != [],
        do: Float.round(Enum.sum(Enum.map(rated, &(&1.rating))) / length(rated), 1),
        else: nil

    %{
      sessions: length(sessions),
      games: length(games),
      wins: wins, losses: losses, draws: draws,
      goals: goals_total,
      assists: assists_total,
      total_distance: Float.round(total_distance * 1.0, 1),
      total_duration: total_duration,
      avg_rating: avg_rating,
      win_rate: if(games != [], do: Float.round(wins / length(games) * 100, 1), else: 0.0)
    }
  end

  def recent_form(%Scope{user: user}, limit \\ 5) do
    Repo.all(from g in GameLog, where: g.user_id == ^user.id,
      order_by: [desc: g.date], limit: ^limit)
  end

  def monthly_session_counts(%Scope{user: user}) do
    Repo.all(
      from s in Session,
        where: s.user_id == ^user.id,
        group_by: fragment("date_trunc('month', ?)", s.date),
        select: {fragment("date_trunc('month', ?)", s.date), count(s.id)},
        order_by: [asc: fragment("date_trunc('month', ?)", s.date)],
        limit: 12
    )
  end

  def generate_insights(%Scope{} = scope) do
    stats = player_stats(scope)
    form = recent_form(scope, 5)
    insights = []

    insights =
      if stats.sessions >= 10 and stats.total_distance > 50 do
        ["💪 You've covered #{stats.total_distance}km across #{stats.sessions} sessions — great endurance!" | insights]
      else
        insights
      end

    insights =
      if stats.win_rate >= 60 do
        ["🏆 #{stats.win_rate}% win rate — you're on fire! Keep up the momentum." | insights]
      else
        insights
      end

    insights =
      cond do
        length(form) >= 3 and Enum.all?(Enum.take(form, 3), &(&1.result == "win")) ->
          ["🔥 3-game winning streak! Confidence must be sky-high." | insights]
        length(form) >= 3 and Enum.all?(Enum.take(form, 3), &(&1.result == "loss")) ->
          ["📉 Tough run of 3 losses. Focus on drill sessions to rebuild sharpness." | insights]
        true -> insights
      end

    insights =
      if stats.goals > 0 and stats.games > 0 do
        rate = Float.round(stats.goals / stats.games, 2)
        if rate >= 0.5,
          do: ["⚽ #{rate} goals per game — clinical finishing!" | insights],
          else: insights
      else
        insights
      end

    insights =
      if insights == [] do
        ["📋 Keep logging sessions and games — insights will appear as your data grows!"]
      else
        insights
      end

    Enum.take(insights, 3)
  end
end
