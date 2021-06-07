defmodule EventBusDatastore do
  @moduledoc """
  Documentation for `EventBusDatastore`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> EventBusDatastore.hello()
      :world

  """
  def process({_topic, _id} = event_shadow) do
    EventBusDatastore.Producer.put(event_shadow)
  end
end

