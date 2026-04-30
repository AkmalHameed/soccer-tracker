defmodule SoccerTracker.Teams.TeamInvite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "team_invites" do
    belongs_to :team, SoccerTracker.Teams.Team
    field :email, :string
    field :token, :string
    field :role, :string, default: "player"
    field :accepted_at, :utc_datetime
    field :expires_at, :utc_datetime
    timestamps(type: :utc_datetime)
  end

  def changeset(invite, attrs) do
    invite
    |> cast(attrs, [:email, :role])
    |> validate_required([:email, :role])
    |> validate_format(:email, ~r/^[^@,;\s]+@[^@,;\s]+$/)
    |> validate_inclusion(:role, ~w(player coach))
  end
end
