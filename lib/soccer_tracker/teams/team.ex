defmodule SoccerTracker.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :description, :string
    field :sport, :string, default: "soccer"
    belongs_to :owner, SoccerTracker.Accounts.User
    has_many :members, SoccerTracker.Teams.TeamMember
    has_many :game_logs, SoccerTracker.Training.GameLog
    timestamps(type: :utc_datetime)
  end

  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
    |> validate_length(:name, min: 2, max: 80)
    |> validate_length(:description, max: 300)
  end
end
