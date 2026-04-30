defmodule SoccerTracker.Programs.ProgramWeek do
  use Ecto.Schema
  import Ecto.Changeset

  schema "program_weeks" do
    belongs_to :program, SoccerTracker.Programs.TrainingProgram
    field :week_number, :integer
    field :theme, :string
    field :notes, :string
    timestamps(type: :utc_datetime)
  end

  def changeset(w, attrs) do
    w |> cast(attrs, [:week_number, :theme, :notes]) |> validate_required([:week_number])
  end
end
