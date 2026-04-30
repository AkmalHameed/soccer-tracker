defmodule SoccerTracker.Teams.TeamMember do
  use Ecto.Schema
  import Ecto.Changeset

  schema "team_members" do
    belongs_to :team, SoccerTracker.Teams.Team
    belongs_to :user, SoccerTracker.Accounts.User
    field :role, :string, default: "player"
    field :position, :string
    field :jersey_number, :integer
    field :joined_at, :utc_datetime
    timestamps(type: :utc_datetime)
  end

  def changeset(member, attrs) do
    member
    |> cast(attrs, [:role, :position, :jersey_number])
    |> validate_inclusion(:role, ~w(player coach))
    |> validate_number(:jersey_number, greater_than: 0, less_than_or_equal_to: 99)
  end
end
