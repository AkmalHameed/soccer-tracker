defmodule SoccerTracker.Repo.Migrations.CreateTrainingPrograms do
  use Ecto.Migration

  def change do
    create table(:training_programs) do
      add :name, :string, null: false
      add :description, :text
      add :duration_weeks, :integer
      add :difficulty, :string
      add :focus, :string              # fitness | technical | tactical | goalkeeping
      add :is_system, :boolean, default: false
      add :created_by_id, references(:users, on_delete: :nilify_all)
      timestamps(type: :utc_datetime)
    end

    create table(:program_weeks) do
      add :program_id, references(:training_programs, on_delete: :delete_all), null: false
      add :week_number, :integer, null: false
      add :theme, :string
      add :notes, :text
      timestamps(type: :utc_datetime)
    end

    create index(:program_weeks, [:program_id])

    create table(:program_week_drills) do
      add :week_id, references(:program_weeks, on_delete: :delete_all), null: false
      add :drill_template_id, references(:drill_templates, on_delete: :delete_all), null: false
      add :day_of_week, :integer        # 1=Mon ... 7=Sun
      add :sets, :integer
      add :reps, :integer
      add :notes, :string
      timestamps(type: :utc_datetime)
    end

    create table(:user_programs) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :program_id, references(:training_programs, on_delete: :delete_all), null: false
      add :started_at, :date
      add :completed_at, :date
      add :current_week, :integer, default: 1
      add :active, :boolean, default: true
      timestamps(type: :utc_datetime)
    end

    create unique_index(:user_programs, [:user_id, :program_id])
  end
end
