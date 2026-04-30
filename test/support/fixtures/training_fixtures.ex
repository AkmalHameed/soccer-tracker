defmodule SoccerTracker.TrainingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SoccerTracker.Training` context.
  """

  @doc """
  Generate a session.
  """
  def session_fixture(attrs \\ %{}) do
    {:ok, session} =
      attrs
      |> Enum.into(%{
        date: ~D[2026-04-15],
        distance: 120.5,
        duration: 42,
        notes: "some notes",
        type: "some type"
      })
      |> SoccerTracker.Training.create_session()

    session
  end

  @doc """
  Generate a drill.
  """
  def drill_fixture(attrs \\ %{}) do
    {:ok, drill} =
      attrs
      |> Enum.into(%{
        duration: 42,
        name: "some name",
        reps: 42,
        sets: 42
      })
      |> SoccerTracker.Training.create_drill()

    drill
  end

  @doc """
  Generate a goal.
  """
  def goal_fixture(attrs \\ %{}) do
    {:ok, goal} =
      attrs
      |> Enum.into(%{
        current_value: 120.5,
        deadline: ~D[2026-04-16],
        target: 120.5,
        type: "some type"
      })
      |> SoccerTracker.Training.create_goal()

    goal
  end
end
