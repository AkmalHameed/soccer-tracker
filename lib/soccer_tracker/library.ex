defmodule SoccerTracker.Library do
  import Ecto.Query, warn: false
  alias SoccerTracker.Repo
  alias SoccerTracker.Library.DrillTemplate

  def list_drill_templates(filters \\ %{}) do
    query = from d in DrillTemplate, order_by: [asc: d.category, asc: d.name]

    query =
      if filters[:category] && filters[:category] != "" do
        where(query, [d], d.category == ^filters[:category])
      else
        query
      end

    query =
      if filters[:difficulty] && filters[:difficulty] != "" do
        where(query, [d], d.difficulty == ^filters[:difficulty])
      else
        query
      end

    query =
      if filters[:search] && filters[:search] != "" do
        term = "%#{filters[:search]}%"
        where(query, [d], ilike(d.name, ^term) or ilike(d.description, ^term))
      else
        query
      end

    Repo.all(query)
  end

  def get_drill_template!(id), do: Repo.get!(DrillTemplate, id)

  def create_drill_template(user_id, attrs) do
    %DrillTemplate{created_by_id: user_id, is_system: false}
    |> DrillTemplate.changeset(attrs)
    |> Repo.insert()
  end

  def change_drill_template(%DrillTemplate{} = d, attrs \\ %{}) do
    DrillTemplate.changeset(d, attrs)
  end

  def categories_with_counts do
    Repo.all(
      from d in DrillTemplate,
        group_by: d.category,
        select: {d.category, count(d.id)}
    )
    |> Enum.into(%{})
  end
end
