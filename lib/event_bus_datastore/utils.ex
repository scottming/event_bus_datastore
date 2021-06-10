defmodule EventBusDatastore.Utils do
  def now do
    System.os_time(time_unit())
  end

  defp time_unit do
    Application.get_env(:event_bus, :time_unit, :microsecond)
  end
end

