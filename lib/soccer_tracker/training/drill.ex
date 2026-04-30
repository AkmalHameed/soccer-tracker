defmodule SoccerTracker.Training.Drill do
  use Ecto.Schema
  import Ecto.Changeset

  schema "drills" do
    field :name, :string
    field :sets, :integer
    field :reps, :integer
    field :duration, :integer
    belongs_to :session, SoccerTracker.Training.Session

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(drill, attrs) do
    drill
    |> cast(attrs, [:name, :sets, :reps, :duration, :session_id])
    |> validate_required([:name, :sets, :reps, :duration, :session_id])
    |> validate_length(:name, min: 2, max: 100)
    |> validate_number(:sets, greater_than: 0)
    |> validate_number(:reps, greater_than: 0)
    |> validate_number(:duration, greater_than: 0)
    |> foreign_key_constraint(:session_id)
  end
end
