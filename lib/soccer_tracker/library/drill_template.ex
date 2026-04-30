defmodule SoccerTracker.Library.DrillTemplate do
  use Ecto.Schema
  import Ecto.Changeset

  @categories ~w(passing shooting dribbling fitness defending goalkeeping)
  @difficulties ~w(beginner intermediate advanced)

  schema "drill_templates" do
    field :name, :string
    field :description, :string
    field :category, :string
    field :difficulty, :string
    field :duration_minutes, :integer
    field :players_needed, :integer
    field :instructions, :string
    field :tips, :string
    field :equipment, :string
    field :is_system, :boolean, default: false
    belongs_to :created_by, SoccerTracker.Accounts.User
    timestamps(type: :utc_datetime)
  end

  def categories, do: @categories
  def difficulties, do: @difficulties

  def changeset(drill, attrs) do
    drill
    |> cast(attrs, [:name, :description, :category, :difficulty, :duration_minutes,
                    :players_needed, :instructions, :tips, :equipment])
    |> validate_required([:name, :category, :difficulty])
    |> validate_length(:name, min: 3, max: 100)
    |> validate_inclusion(:category, @categories)
    |> validate_inclusion(:difficulty, @difficulties)
    |> validate_number(:duration_minutes, greater_than: 0)
    |> validate_number(:players_needed, greater_than: 0)
  end
end
