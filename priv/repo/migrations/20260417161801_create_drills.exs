defmodule SoccerTracker.Repo.Migrations.CreateDrills do
  use Ecto.Migration

  def change do
    create table(:drills) do
      add :name, :string
      add :sets, :integer
      add :reps, :integer
      add :duration, :integer
      add :session_id, references(:sessions, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:drills, [:session_id])
  end
end
