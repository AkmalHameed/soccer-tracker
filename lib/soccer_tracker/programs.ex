defmodule SoccerTracker.Programs do
  import Ecto.Query, warn: false
  alias SoccerTracker.Repo
  alias SoccerTracker.Accounts.Scope
  alias SoccerTracker.Programs.{TrainingProgram, UserProgram}

  def list_programs do
    Repo.all(from p in TrainingProgram, order_by: [asc: p.focus, asc: p.name])
  end

  def get_program!(id) do
    Repo.get!(TrainingProgram, id)
    |> Repo.preload(weeks: :program)
  end

  def enroll(%Scope{user: user}, program_id) do
    case Repo.get_by(UserProgram, user_id: user.id, program_id: program_id) do
      nil ->
        %UserProgram{user_id: user.id, program_id: program_id,
          started_at: Date.utc_today(), active: true, current_week: 1}
        |> Repo.insert()
      existing ->
        existing
        |> Ecto.Changeset.change(active: true, current_week: 1, started_at: Date.utc_today(), completed_at: nil)
        |> Repo.update()
    end
  end

  def list_my_programs(%Scope{user: user}) do
    Repo.all(
      from up in UserProgram,
        where: up.user_id == ^user.id and up.active == true,
        preload: :program
    )
  end

  def advance_week(%Scope{user: user}, program_id) do
    up = Repo.get_by!(UserProgram, user_id: user.id, program_id: program_id)
    program = get_program!(program_id)
    new_week = up.current_week + 1
    if new_week > program.duration_weeks do
      up |> Ecto.Changeset.change(active: false, completed_at: Date.utc_today()) |> Repo.update()
    else
      up |> Ecto.Changeset.change(current_week: new_week) |> Repo.update()
    end
  end
end
