defmodule EventBusDatastoreTest do
  use ExUnit.Case
  use EventBus.EventSource
  import TestHelper
  alias EventBusDatastore.Store

  setup_all [:create_events_table]

  setup do
    register_topics([:user_created])
  end

  @tag :integration
  test "greets events" do
    event =
      EventSource.build make_event_params() do
        %{email: "foo@example.com", name: "foo"}
      end

    EventBus.notify(event)
    Process.sleep(1100)
    assert length(Store.all()) == 1
  end

  def make_event_params(topic \\ :user_created) do
    id = UUID.uuid4()
    topic = topic
    transaction_id = UUID.uuid4()
    source = "my event creator"
    %{id: id, topic: topic, transaction_id: transaction_id, source: source}
  end
end

