defmodule SoccerTracker.Repo.Migrations.CreateGoals do
  use Ecto.Migration

  def change do
    create table(:goals) do
      add :type, :string
      add :target, :float
      add :current_value, :float
      add :deadline, :date
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:goals, [:user_id])
  end
end
