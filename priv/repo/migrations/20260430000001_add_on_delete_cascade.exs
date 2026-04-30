defmodule SoccerTracker.Repo.Migrations.AddOnDeleteCascade do
  use Ecto.Migration

  def change do
    # Drop old foreign keys and re-add with cascade delete
    drop constraint(:sessions, "sessions_user_id_fkey")
    drop constraint(:goals, "goals_user_id_fkey")
    drop constraint(:drills, "drills_session_id_fkey")

    alter table(:sessions) do
      modify :user_id, references(:users, on_delete: :delete_all)
    end

    alter table(:goals) do
      modify :user_id, references(:users, on_delete: :delete_all)
    end

    alter table(:drills) do
      modify :session_id, references(:sessions, on_delete: :delete_all)
    end
  end
end
