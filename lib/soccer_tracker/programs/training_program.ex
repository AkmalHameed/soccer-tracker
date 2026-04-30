defmodule SoccerTracker.Programs.TrainingProgram do
  use Ecto.Schema
  import Ecto.Changeset

  schema "training_programs" do
    field :name, :string
    field :description, :string
    field :duration_weeks, :integer
    field :difficulty, :string
    field :focus, :string
    field :is_system, :boolean, default: false
    belongs_to :created_by, SoccerTracker.Accounts.User
    has_many :weeks, SoccerTracker.Programs.ProgramWeek, foreign_key: :program_id
    timestamps(type: :utc_datetime)
  end

  def changeset(p, attrs) do
    p
    |> cast(attrs, [:name, :description, :duration_weeks, :difficulty, :focus])
    |> validate_required([:name, :duration_weeks, :difficulty, :focus])
    |> validate_number(:duration_weeks, greater_than: 0, less_than_or_equal_to: 52)
    |> validate_inclusion(:difficulty, ~w(beginner intermediate advanced))
    |> validate_inclusion(:focus, ~w(fitness technical tactical goalkeeping mixed))
  end
end
