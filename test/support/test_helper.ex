defmodule TestHelper do
  def drop_events_table(%{pg: pg}) do
    drop_sqls = [
      """
      DROP table if exists "event_bus_events" 
      """
    ]

    for statment <- drop_sqls, do: Postgrex.query!(pg, statment, [])

    {:ok, %{pg: pg}}
  end

  def create_events_table(_ctx) do
    {:ok, pg} = Postgrex.start_link(Application.fetch_env!(:event_bus_datastore, :postgrex))

    drop_events_table(%{pg: pg})

    create_sqls = EventBusDatastore.Migration.statements()

    for statement <- create_sqls, do: Postgrex.query!(pg, statement, [])

    {:ok, %{pg: pg}}
  end
end

