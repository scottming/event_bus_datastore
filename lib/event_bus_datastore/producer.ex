defmodule EventBusDatastore.Producer do
  @moduledoc """
  Postgres queue (producer)
  """

  use GenStage
  alias Broadway.Message

  def init(state) do
    IO.puts("EventBusDatastore producer is starting")
    {:producer, state, buffer_size: :infinity}
  end

  def start_link(state \\ []) do
    GenStage.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
  Push event shadows to queue
  """
  @spec put({atom(), String.t() | integer()}) :: :ok
  def put({_topic, _id} = event_shadow) do
    EventBusDatastore.Pipeline
    |> Broadway.producer_names()
    |> List.first()
    |> GenStage.cast({:put, event_shadow})
  end

  @doc false
  def handle_cast({:put, event_shadow}, state) do
    events = [
      %Message{
        data: "1",
        metadata: event_shadow,
        acknowledger: {Broadway.NoopAcknowledger, nil, nil}
      }
    ]

    {:noreply, events, state}
  end

  @doc false
  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end
end

