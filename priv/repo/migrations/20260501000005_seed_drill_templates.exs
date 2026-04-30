defmodule SoccerTracker.Repo.Migrations.SeedDrillTemplates do
  use Ecto.Migration
  import Ecto.Query

  def up do
    now = DateTime.utc_now(:second)

    drills = [
      # PASSING
      %{name: "Triangle Passing", category: "passing", difficulty: "beginner",
        duration_minutes: 15, players_needed: 3,
        description: "Three players form a triangle and pass the ball around, focusing on accuracy and first touch.",
        instructions: "1. Set up three cones in a triangle ~10m apart.\n2. One player at each cone.\n3. Pass to the right, follow your pass.\n4. Rotate after 5 minutes.",
        tips: "Keep your head up. Use the inside of your foot for accuracy.", equipment: "3 cones, 1 ball"},
      %{name: "One-Two Combination", category: "passing", difficulty: "intermediate",
        duration_minutes: 20, players_needed: 2,
        description: "Wall pass drill focusing on quick one-touch combinations.",
        instructions: "1. Player A passes to Player B.\n2. Player B plays a one-touch return.\n3. Player A receives on the run.\n4. Switch roles every 5 minutes.",
        tips: "Communication is key. Call for the ball.", equipment: "1 ball"},
      %{name: "Rondo (4v1)", category: "passing", difficulty: "intermediate",
        duration_minutes: 20, players_needed: 5,
        description: "Four players keep possession in a small area against one defender.",
        instructions: "1. Set up a 8m x 8m grid.\n2. 4 players on outside, 1 in the middle.\n3. Outside players maintain possession.\n4. If defender wins ball, the player who lost it goes in the middle.",
        tips: "Move the ball quickly. Create angles for teammates.", equipment: "4 cones, 1 ball"},
      # SHOOTING
      %{name: "Shooting from Range", category: "shooting", difficulty: "beginner",
        duration_minutes: 20, players_needed: 1,
        description: "Strike the ball from 18-25 yards with power and accuracy.",
        instructions: "1. Place ball 20 yards from goal.\n2. Approach at a slight angle.\n3. Strike with your laces through the ball.\n4. Aim for corners. Take 10 shots, rest, repeat.",
        tips: "Plant foot beside the ball. Follow through toward the target.", equipment: "6 balls, goal"},
      %{name: "First-Time Finish", category: "shooting", difficulty: "intermediate",
        duration_minutes: 25, players_needed: 2,
        description: "Finish crosses and through balls on the first touch.",
        instructions: "1. Server delivers balls from wide positions.\n2. Shooter moves to meet the ball.\n3. Finish with one touch toward goal.\n4. Alternate left and right service.",
        tips: "Get your body over the ball. Decide where you're shooting before the ball arrives.", equipment: "8 balls, goal"},
      %{name: "1v1 vs Goalkeeper", category: "shooting", difficulty: "advanced",
        duration_minutes: 30, players_needed: 2,
        description: "Beat the goalkeeper in a 1-on-1 situation.",
        instructions: "1. Player starts 30 yards from goal.\n2. Dribble toward keeper.\n3. Use feints, chip, or placement to score.\n4. Goalkeeper tries to narrow the angle.",
        tips: "Stay calm. Pick your spot early. Don't always blast it.", equipment: "Balls, goal, goalkeeper"},
      # DRIBBLING
      %{name: "Cone Slalom", category: "dribbling", difficulty: "beginner",
        duration_minutes: 15, players_needed: 1,
        description: "Dribble through a line of cones using close control.",
        instructions: "1. Set up 8 cones in a line, 1m apart.\n2. Dribble through using alternating feet.\n3. Return on the outside.\n4. Time yourself and try to beat your record.",
        tips: "Keep the ball close. Use the inside and outside of both feet.", equipment: "8 cones, 1 ball"},
      %{name: "Box Dribbling", category: "dribbling", difficulty: "intermediate",
        duration_minutes: 20, players_needed: 1,
        description: "Dribble in a confined box, performing moves at each corner.",
        instructions: "1. Set up a 10m x 10m box.\n2. Dribble to each corner.\n3. Perform a specific move at each corner (step-over, Cruyff, chop).\n4. Change direction randomly.",
        tips: "Use your body to shield the ball. Change pace.", equipment: "4 cones, 1 ball"},
      # FITNESS
      %{name: "Interval Sprints", category: "fitness", difficulty: "intermediate",
        duration_minutes: 25, players_needed: 1,
        description: "High-intensity sprints to improve speed and cardiovascular fitness.",
        instructions: "1. Mark out 30 yards.\n2. Sprint full speed.\n3. Walk back to recover (60 seconds).\n4. Repeat 8-12 times.\n5. Rest 3 minutes. Do 2 sets.",
        tips: "Drive your arms. Stay on your toes. Quality over quantity.", equipment: "2 cones"},
      %{name: "Shuttle Runs (Beep Test)", category: "fitness", difficulty: "advanced",
        duration_minutes: 30, players_needed: 1,
        description: "Multi-stage fitness test to measure aerobic capacity.",
        instructions: "1. Set cones 20m apart.\n2. Run between cones in time to audio beeps.\n3. Speed increases each minute.\n4. Continue until you can't reach the line in time.",
        tips: "Pace yourself early. Touch the line with your foot.", equipment: "2 cones, audio player"},
      # DEFENDING
      %{name: "Jockeying 1v1", category: "defending", difficulty: "intermediate",
        duration_minutes: 20, players_needed: 2,
        description: "Learn to delay attackers and force them to less dangerous areas.",
        instructions: "1. Attacker starts with ball at top of box.\n2. Defender adopts side-on stance.\n3. Guide attacker toward touchline.\n4. No sliding tackles. Win ball with patience.",
        tips: "Stay low. Don't dive in. Watch the ball, not the player.", equipment: "1 ball, cones"},
      %{name: "Shadow Defending", category: "defending", difficulty: "beginner",
        duration_minutes: 15, players_needed: 2,
        description: "Practice defensive positioning and movement without contact.",
        instructions: "1. Attacker dribbles freely in zone.\n2. Defender mirrors their movement, staying 2m away.\n3. Defender focuses on positioning and footwork.\n4. No contact — pure movement drill.",
        tips: "Stay goal-side. Keep your center of gravity low.", equipment: "Cones, 1 ball"},
      # GOALKEEPING
      %{name: "Shot Stopping — Low Shots", category: "goalkeeping", difficulty: "beginner",
        duration_minutes: 20, players_needed: 2,
        description: "Practice diving saves and low shots to either side.",
        instructions: "1. Server rolls balls to left and right of keeper.\n2. Keeper dives to save.\n3. Focus on getting body behind the ball.\n4. 10 shots each side, rest, repeat.",
        tips: "Collapse the near side. Get your body low early.", equipment: "8 balls, goal"},
      %{name: "Cross Claiming", category: "goalkeeping", difficulty: "intermediate",
        duration_minutes: 25, players_needed: 2,
        description: "Command the penalty area to claim crosses confidently.",
        instructions: "1. Server crosses from both wings.\n2. Goalkeeper must call 'KEEPER' and take the ball at highest point.\n3. Land safely and distribute quickly.",
        tips: "Come early and decisively. Two hands on the ball.", equipment: "Balls, goal, cones"}
    ]

    Enum.each(drills, fn drill ->
      execute """
        INSERT INTO drill_templates (name, description, category, difficulty, duration_minutes,
          players_needed, instructions, tips, equipment, is_system, inserted_at, updated_at)
        VALUES ('#{escape(drill.name)}', '#{escape(drill.description)}', '#{drill.category}',
          '#{drill.difficulty}', #{drill.duration_minutes}, #{drill.players_needed},
          '#{escape(drill.instructions)}', '#{escape(drill.tips)}',
          '#{escape(drill.equipment)}', true,
          '#{DateTime.to_string(now)}', '#{DateTime.to_string(now)}')
      """
    end)
  end

  def down do
    execute "DELETE FROM drill_templates WHERE is_system = true"
  end

  defp escape(str), do: String.replace(str, "'", "''")
end
