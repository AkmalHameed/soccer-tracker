defmodule SoccerTrackerWeb.DrillLiveTest do
  use SoccerTrackerWeb.ConnCase

  import Phoenix.LiveViewTest
  import SoccerTracker.TrainingFixtures

  @create_attrs %{name: "some name", sets: 42, reps: 42, duration: 42}
  @update_attrs %{name: "some updated name", sets: 43, reps: 43, duration: 43}
  @invalid_attrs %{name: nil, sets: nil, reps: nil, duration: nil}
  defp create_drill(_) do
    drill = drill_fixture()

    %{drill: drill}
  end

  describe "Index" do
    setup [:create_drill]

    test "lists all drills", %{conn: conn, drill: drill} do
      {:ok, _index_live, html} = live(conn, ~p"/drills")

      assert html =~ "Listing Drills"
      assert html =~ drill.name
    end

    test "saves new drill", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/drills")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Drill")
               |> render_click()
               |> follow_redirect(conn, ~p"/drills/new")

      assert render(form_live) =~ "New Drill"

      assert form_live
             |> form("#drill-form", drill: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#drill-form", drill: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/drills")

      html = render(index_live)
      assert html =~ "Drill created successfully"
      assert html =~ "some name"
    end

    test "updates drill in listing", %{conn: conn, drill: drill} do
      {:ok, index_live, _html} = live(conn, ~p"/drills")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#drills-#{drill.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/drills/#{drill}/edit")

      assert render(form_live) =~ "Edit Drill"

      assert form_live
             |> form("#drill-form", drill: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#drill-form", drill: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/drills")

      html = render(index_live)
      assert html =~ "Drill updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes drill in listing", %{conn: conn, drill: drill} do
      {:ok, index_live, _html} = live(conn, ~p"/drills")

      assert index_live |> element("#drills-#{drill.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#drills-#{drill.id}")
    end
  end

  describe "Show" do
    setup [:create_drill]

    test "displays drill", %{conn: conn, drill: drill} do
      {:ok, _show_live, html} = live(conn, ~p"/drills/#{drill}")

      assert html =~ "Show Drill"
      assert html =~ drill.name
    end

    test "updates drill and returns to show", %{conn: conn, drill: drill} do
      {:ok, show_live, _html} = live(conn, ~p"/drills/#{drill}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/drills/#{drill}/edit?return_to=show")

      assert render(form_live) =~ "Edit Drill"

      assert form_live
             |> form("#drill-form", drill: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#drill-form", drill: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/drills/#{drill}")

      html = render(show_live)
      assert html =~ "Drill updated successfully"
      assert html =~ "some updated name"
    end
  end
end
