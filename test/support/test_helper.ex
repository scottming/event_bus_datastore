defmodule TestHelper do
  alias TestApp.Repo

  def drop_events_table(_ctx) do
    drop_sqls = [
      """
      DROP table if exists "event_bus_events" 
      """
    ]

    for statment <- drop_sqls, do: Repo.query!(statment, [])
    :ok
  end

  def create_events_table(_ctx) do
    drop_events_table(%{})
    create_sqls = EventBusDatastore.Migration.statements()
    for statement <- create_sqls, do: Repo.query!(statement, [])
    :ok
  end

  def register_topics(topics) when is_list(topics) do
    topics |> Enum.each(fn x -> EventBus.register_topic(x) end)
  end
end

