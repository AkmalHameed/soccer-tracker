defmodule SoccerTracker.Training.GameLog do
  use Ecto.Schema
  import Ecto.Changeset

  @positions ~w(Goalkeeper Defender Midfielder Forward Winger Striker)
  @results ~w(win loss draw)

  schema "game_logs" do
    field :date, :date
    field :opponent, :string
    field :location, :string
    field :our_score, :integer
    field :opponent_score, :integer
    field :result, :string
    field :position_played, :string
    field :minutes_played, :integer
    field :goals, :integer, default: 0
    field :assists, :integer, default: 0
    field :shots, :integer, default: 0
    field :shots_on_target, :integer, default: 0
    field :saves, :integer, default: 0
    field :goals_conceded, :integer, default: 0
    field :yellow_cards, :integer, default: 0
    field :red_cards, :integer, default: 0
    field :rating, :integer
    field :notes, :string
    belongs_to :user, SoccerTracker.Accounts.User
    belongs_to :team, SoccerTracker.Teams.Team
    timestamps(type: :utc_datetime)
  end

  def positions, do: @positions
  def results, do: @results

  def changeset(g, attrs) do
    g
    |> cast(attrs, [:date, :opponent, :location, :our_score, :opponent_score, :result,
                    :position_played, :minutes_played, :goals, :assists, :shots,
                    :shots_on_target, :saves, :goals_conceded, :yellow_cards,
                    :red_cards, :rating, :notes, :team_id])
    |> validate_required([:date, :result])
    |> validate_inclusion(:result, @results)
    |> validate_inclusion(:position_played, @positions ++ [nil])
    |> validate_number(:rating, greater_than_or_equal_to: 1, less_than_or_equal_to: 10)
    |> validate_number(:minutes_played, greater_than: 0, less_than_or_equal_to: 120)
    |> validate_number(:goals, greater_than_or_equal_to: 0)
    |> validate_number(:assists, greater_than_or_equal_to: 0)
  end
end
