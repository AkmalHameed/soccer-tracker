defmodule SoccerTracker.Training.Goal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "goals" do
    field :type, :string
    field :target, :float
    field :current_value, :float
    field :deadline, :date
    belongs_to :user, SoccerTracker.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(goal, attrs) do
    goal
    |> cast(attrs, [:type, :target, :current_value, :deadline])
    |> validate_required([:type, :target, :current_value, :deadline])
    |> validate_length(:type, min: 2, max: 100)
    |> validate_number(:target, greater_than: 0)
    |> validate_number(:current_value, greater_than_or_equal_to: 0)
  end
end
