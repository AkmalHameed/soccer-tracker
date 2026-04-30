defmodule SoccerTracker.TrainingTest do
  use SoccerTracker.DataCase

  alias SoccerTracker.Training

  describe "sessions" do
    alias SoccerTracker.Training.Session

    import SoccerTracker.TrainingFixtures

    @invalid_attrs %{type: nil, date: nil, duration: nil, distance: nil, notes: nil}

    test "list_sessions/0 returns all sessions" do
      session = session_fixture()
      assert Training.list_sessions() == [session]
    end

    test "get_session!/1 returns the session with given id" do
      session = session_fixture()
      assert Training.get_session!(session.id) == session
    end

    test "create_session/1 with valid data creates a session" do
      valid_attrs = %{type: "some type", date: ~D[2026-04-15], duration: 42, distance: 120.5, notes: "some notes"}

      assert {:ok, %Session{} = session} = Training.create_session(valid_attrs)
      assert session.type == "some type"
      assert session.date == ~D[2026-04-15]
      assert session.duration == 42
      assert session.distance == 120.5
      assert session.notes == "some notes"
    end

    test "create_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Training.create_session(@invalid_attrs)
    end

    test "update_session/2 with valid data updates the session" do
      session = session_fixture()
      update_attrs = %{type: "some updated type", date: ~D[2026-04-16], duration: 43, distance: 456.7, notes: "some updated notes"}

      assert {:ok, %Session{} = session} = Training.update_session(session, update_attrs)
      assert session.type == "some updated type"
      assert session.date == ~D[2026-04-16]
      assert session.duration == 43
      assert session.distance == 456.7
      assert session.notes == "some updated notes"
    end

    test "update_session/2 with invalid data returns error changeset" do
      session = session_fixture()
      assert {:error, %Ecto.Changeset{}} = Training.update_session(session, @invalid_attrs)
      assert session == Training.get_session!(session.id)
    end

    test "delete_session/1 deletes the session" do
      session = session_fixture()
      assert {:ok, %Session{}} = Training.delete_session(session)
      assert_raise Ecto.NoResultsError, fn -> Training.get_session!(session.id) end
    end

    test "change_session/1 returns a session changeset" do
      session = session_fixture()
      assert %Ecto.Changeset{} = Training.change_session(session)
    end
  end

  describe "drills" do
    alias SoccerTracker.Training.Drill

    import SoccerTracker.TrainingFixtures

    @invalid_attrs %{name: nil, sets: nil, reps: nil, duration: nil}

    test "list_drills/0 returns all drills" do
      drill = drill_fixture()
      assert Training.list_drills() == [drill]
    end

    test "get_drill!/1 returns the drill with given id" do
      drill = drill_fixture()
      assert Training.get_drill!(drill.id) == drill
    end

    test "create_drill/1 with valid data creates a drill" do
      valid_attrs = %{name: "some name", sets: 42, reps: 42, duration: 42}

      assert {:ok, %Drill{} = drill} = Training.create_drill(valid_attrs)
      assert drill.name == "some name"
      assert drill.sets == 42
      assert drill.reps == 42
      assert drill.duration == 42
    end

    test "create_drill/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Training.create_drill(@invalid_attrs)
    end

    test "update_drill/2 with valid data updates the drill" do
      drill = drill_fixture()
      update_attrs = %{name: "some updated name", sets: 43, reps: 43, duration: 43}

      assert {:ok, %Drill{} = drill} = Training.update_drill(drill, update_attrs)
      assert drill.name == "some updated name"
      assert drill.sets == 43
      assert drill.reps == 43
      assert drill.duration == 43
    end

    test "update_drill/2 with invalid data returns error changeset" do
      drill = drill_fixture()
      assert {:error, %Ecto.Changeset{}} = Training.update_drill(drill, @invalid_attrs)
      assert drill == Training.get_drill!(drill.id)
    end

    test "delete_drill/1 deletes the drill" do
      drill = drill_fixture()
      assert {:ok, %Drill{}} = Training.delete_drill(drill)
      assert_raise Ecto.NoResultsError, fn -> Training.get_drill!(drill.id) end
    end

    test "change_drill/1 returns a drill changeset" do
      drill = drill_fixture()
      assert %Ecto.Changeset{} = Training.change_drill(drill)
    end
  end

  describe "goals" do
    alias SoccerTracker.Training.Goal

    import SoccerTracker.TrainingFixtures

    @invalid_attrs %{type: nil, deadline: nil, target: nil, current_value: nil}

    test "list_goals/0 returns all goals" do
      goal = goal_fixture()
      assert Training.list_goals() == [goal]
    end

    test "get_goal!/1 returns the goal with given id" do
      goal = goal_fixture()
      assert Training.get_goal!(goal.id) == goal
    end

    test "create_goal/1 with valid data creates a goal" do
      valid_attrs = %{type: "some type", deadline: ~D[2026-04-16], target: 120.5, current_value: 120.5}

      assert {:ok, %Goal{} = goal} = Training.create_goal(valid_attrs)
      assert goal.type == "some type"
      assert goal.deadline == ~D[2026-04-16]
      assert goal.target == 120.5
      assert goal.current_value == 120.5
    end

    test "create_goal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Training.create_goal(@invalid_attrs)
    end

    test "update_goal/2 with valid data updates the goal" do
      goal = goal_fixture()
      update_attrs = %{type: "some updated type", deadline: ~D[2026-04-17], target: 456.7, current_value: 456.7}

      assert {:ok, %Goal{} = goal} = Training.update_goal(goal, update_attrs)
      assert goal.type == "some updated type"
      assert goal.deadline == ~D[2026-04-17]
      assert goal.target == 456.7
      assert goal.current_value == 456.7
    end

    test "update_goal/2 with invalid data returns error changeset" do
      goal = goal_fixture()
      assert {:error, %Ecto.Changeset{}} = Training.update_goal(goal, @invalid_attrs)
      assert goal == Training.get_goal!(goal.id)
    end

    test "delete_goal/1 deletes the goal" do
      goal = goal_fixture()
      assert {:ok, %Goal{}} = Training.delete_goal(goal)
      assert_raise Ecto.NoResultsError, fn -> Training.get_goal!(goal.id) end
    end

    test "change_goal/1 returns a goal changeset" do
      goal = goal_fixture()
      assert %Ecto.Changeset{} = Training.change_goal(goal)
    end
  end
end
