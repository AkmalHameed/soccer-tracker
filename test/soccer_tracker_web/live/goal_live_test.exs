defmodule SoccerTrackerWeb.GoalLiveTest do
  use SoccerTrackerWeb.ConnCase

  import Phoenix.LiveViewTest
  import SoccerTracker.TrainingFixtures

  @create_attrs %{type: "some type", deadline: "2026-04-16", target: 120.5, current_value: 120.5}
  @update_attrs %{type: "some updated type", deadline: "2026-04-17", target: 456.7, current_value: 456.7}
  @invalid_attrs %{type: nil, deadline: nil, target: nil, current_value: nil}
  defp create_goal(_) do
    goal = goal_fixture()

    %{goal: goal}
  end

  describe "Index" do
    setup [:create_goal]

    test "lists all goals", %{conn: conn, goal: goal} do
      {:ok, _index_live, html} = live(conn, ~p"/goals")

      assert html =~ "Listing Goals"
      assert html =~ goal.type
    end

    test "saves new goal", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/goals")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Goal")
               |> render_click()
               |> follow_redirect(conn, ~p"/goals/new")

      assert render(form_live) =~ "New Goal"

      assert form_live
             |> form("#goal-form", goal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#goal-form", goal: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/goals")

      html = render(index_live)
      assert html =~ "Goal created successfully"
      assert html =~ "some type"
    end

    test "updates goal in listing", %{conn: conn, goal: goal} do
      {:ok, index_live, _html} = live(conn, ~p"/goals")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#goals-#{goal.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/goals/#{goal}/edit")

      assert render(form_live) =~ "Edit Goal"

      assert form_live
             |> form("#goal-form", goal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#goal-form", goal: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/goals")

      html = render(index_live)
      assert html =~ "Goal updated successfully"
      assert html =~ "some updated type"
    end

    test "deletes goal in listing", %{conn: conn, goal: goal} do
      {:ok, index_live, _html} = live(conn, ~p"/goals")

      assert index_live |> element("#goals-#{goal.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#goals-#{goal.id}")
    end
  end

  describe "Show" do
    setup [:create_goal]

    test "displays goal", %{conn: conn, goal: goal} do
      {:ok, _show_live, html} = live(conn, ~p"/goals/#{goal}")

      assert html =~ "Show Goal"
      assert html =~ goal.type
    end

    test "updates goal and returns to show", %{conn: conn, goal: goal} do
      {:ok, show_live, _html} = live(conn, ~p"/goals/#{goal}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/goals/#{goal}/edit?return_to=show")

      assert render(form_live) =~ "Edit Goal"

      assert form_live
             |> form("#goal-form", goal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#goal-form", goal: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/goals/#{goal}")

      html = render(show_live)
      assert html =~ "Goal updated successfully"
      assert html =~ "some updated type"
    end
  end
end
