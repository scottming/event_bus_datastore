defmodule EventBusDatastoreTest do
  use ExUnit.Case
  import TestHelper

  setup [:create_events_table]

  test "greets the world" do
    assert 1 == 1
  end
end

