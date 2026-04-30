defmodule SoccerTracker.Training.Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sessions" do
    field :date, :date
    field :duration, :integer
    field :type, :string
    field :distance, :float
    field :notes, :string
    belongs_to :user, SoccerTracker.Accounts.User
    has_many :drills, SoccerTracker.Training.Drill

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:date, :duration, :type, :distance, :notes])
    |> validate_required([:date, :duration, :type, :distance])
    |> validate_number(:duration, greater_than: 0, message: "must be greater than 0")
    |> validate_number(:distance, greater_than_or_equal_to: 0, message: "must be 0 or greater")
    |> validate_length(:notes, max: 500)
    |> validate_inclusion(:type, ~w(Training Match Fitness Friendly Other),
        message: "must be one of: Training, Match, Fitness, Friendly, Other")
  end
end
