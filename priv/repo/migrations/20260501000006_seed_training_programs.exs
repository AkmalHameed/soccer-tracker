defmodule SoccerTracker.Repo.Migrations.SeedTrainingPrograms do
  use Ecto.Migration

  def up do
    now = DateTime.utc_now(:second) |> DateTime.to_string()

    programs = [
      %{name: "Pre-Season Fitness", description: "Build your cardiovascular base and running endurance before the season starts. Focuses on distance, intervals, and conditioning.", duration_weeks: 6, difficulty: "intermediate", focus: "fitness"},
      %{name: "Striker's Finishing School", description: "Sharpen your goal-scoring instincts with dedicated shooting, positioning, and 1v1 exercises.", duration_weeks: 4, difficulty: "intermediate", focus: "technical"},
      %{name: "Beginner's Foundation", description: "Perfect for new players. Learn the fundamentals of passing, dribbling, and basic fitness.", duration_weeks: 8, difficulty: "beginner", focus: "mixed"},
      %{name: "Goalkeeper Elite", description: "Advanced shot-stopping, distribution, and aerial training for serious keepers.", duration_weeks: 6, difficulty: "advanced", focus: "goalkeeping"},
      %{name: "Midfielder Masterclass", description: "Improve your vision, passing range, pressing, and engine to dominate the middle of the park.", duration_weeks: 5, difficulty: "advanced", focus: "tactical"},
      %{name: "Speed & Agility", description: "Sprint training, lateral movement drills, and quick-feet exercises to make you faster and more explosive.", duration_weeks: 4, difficulty: "intermediate", focus: "fitness"},
    ]

    Enum.each(programs, fn p ->
      execute """
        INSERT INTO training_programs (name, description, duration_weeks, difficulty, focus, is_system, inserted_at, updated_at)
        VALUES ('#{escape(p.name)}', '#{escape(p.description)}', #{p.duration_weeks},
          '#{p.difficulty}', '#{p.focus}', true, '#{now}', '#{now}')
      """
    end)
  end

  def down do
    execute "DELETE FROM training_programs WHERE is_system = true"
  end

  defp escape(str), do: String.replace(str, "'", "''")
end
