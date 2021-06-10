defmodule EventBusDatastore.Pipeline do
  use Broadway
  alias Broadway.Message
  alias EventBusDatastore.Store
  require Logger

  def start_link(opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {EventBusDatastore.Producer, opts},
        concurrency: 1
      ],
      processors: [
        default: [concurrency: 10]
      ],
      batchers: [
        default: [batch_size: 50, batch_timeout: 1000],
        insert_all: [batch_size: 50, batch_timeout: 1000]
      ]
    )
  end

  @impl true
  def handle_message(_, %{data: {_topic, _id}} = message, _) do
    message
    |> Message.update_data(&process_data/1)
    |> Message.put_batcher(:insert_all)
  end

  @impl true
  def handle_message(_, message, _) do
    message
  end

  def process_data(event_shadow) do
    event = EventBus.fetch_event(event_shadow) |> EventBusDatastore.Schemas.Event.from_eb_event()
    EventBus.mark_as_completed({EventBusDatastore, event_shadow})
    event
  end

  @impl true
  def handle_batch(:insert_all, messages, _, _) do
    events = messages |> Enum.map(& &1.data)
    Store.batch_insert(events)
    messages
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    messages
  end
end

