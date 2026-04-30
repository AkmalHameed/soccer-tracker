defmodule SoccerTracker.Programs.UserProgram do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_programs" do
    belongs_to :user, SoccerTracker.Accounts.User
    belongs_to :program, SoccerTracker.Programs.TrainingProgram
    field :started_at, :date
    field :completed_at, :date
    field :current_week, :integer, default: 1
    field :active, :boolean, default: true
    timestamps(type: :utc_datetime)
  end

  def changeset(up, attrs) do
    up |> cast(attrs, [:started_at, :current_week, :active, :completed_at])
  end
end
