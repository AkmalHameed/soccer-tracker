defmodule SoccerTracker.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :date, :date
      add :duration, :integer
      add :type, :string
      add :distance, :float
      add :notes, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:sessions, [:user_id])
  end
end
