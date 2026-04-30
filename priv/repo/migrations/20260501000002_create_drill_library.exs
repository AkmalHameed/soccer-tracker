defmodule SoccerTracker.Repo.Migrations.CreateDrillLibrary do
  use Ecto.Migration

  def change do
    create table(:drill_templates) do
      add :name, :string, null: false
      add :description, :text
      add :category, :string           # passing | shooting | dribbling | fitness | defending | goalkeeping
      add :difficulty, :string         # beginner | intermediate | advanced
      add :duration_minutes, :integer
      add :players_needed, :integer
      add :instructions, :text
      add :tips, :text
      add :equipment, :string
      add :is_system, :boolean, default: false   # built-in vs user-created
      add :created_by_id, references(:users, on_delete: :nilify_all)
      timestamps(type: :utc_datetime)
    end

    create index(:drill_templates, [:category])
    create index(:drill_templates, [:is_system])
  end
end
