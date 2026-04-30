defmodule SoccerTracker.Repo.Migrations.CreateGameLogs do
  use Ecto.Migration

  def change do
    create table(:game_logs) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :team_id, references(:teams, on_delete: :nilify_all)
      add :date, :date, null: false
      add :opponent, :string
      add :location, :string
      add :our_score, :integer
      add :opponent_score, :integer
      add :result, :string             # win | loss | draw
      add :position_played, :string
      add :minutes_played, :integer
      add :goals, :integer, default: 0
      add :assists, :integer, default: 0
      add :shots, :integer, default: 0
      add :shots_on_target, :integer, default: 0
      add :saves, :integer, default: 0        # for goalies
      add :goals_conceded, :integer, default: 0
      add :yellow_cards, :integer, default: 0
      add :red_cards, :integer, default: 0
      add :rating, :integer            # self-rating 1-10
      add :notes, :text
      timestamps(type: :utc_datetime)
    end

    create index(:game_logs, [:user_id])
    create index(:game_logs, [:team_id])
    create index(:game_logs, [:date])
  end
end
