defmodule SoccerTracker.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string, null: false
      add :description, :text
      add :sport, :string, default: "soccer"
      add :owner_id, references(:users, on_delete: :delete_all), null: false
      timestamps(type: :utc_datetime)
    end

    create index(:teams, [:owner_id])

    create table(:team_members) do
      add :team_id, references(:teams, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :role, :string, default: "player"   # player | coach
      add :position, :string
      add :jersey_number, :integer
      add :joined_at, :utc_datetime
      timestamps(type: :utc_datetime)
    end

    create unique_index(:team_members, [:team_id, :user_id])
    create index(:team_members, [:user_id])

    create table(:team_invites) do
      add :team_id, references(:teams, on_delete: :delete_all), null: false
      add :email, :string, null: false
      add :token, :string, null: false
      add :role, :string, default: "player"
      add :accepted_at, :utc_datetime
      add :expires_at, :utc_datetime
      timestamps(type: :utc_datetime)
    end

    create unique_index(:team_invites, [:token])
    create index(:team_invites, [:team_id])
    create index(:team_invites, [:email])
  end
end
