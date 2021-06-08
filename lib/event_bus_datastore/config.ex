defmodule EventBusDatastore.Config do
  def events_table_name do
    Application.get_env(:event_bus_datastore, :events_table_name, "event_bus_events")
  end
end

