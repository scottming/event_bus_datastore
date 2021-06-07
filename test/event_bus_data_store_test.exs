defmodule EventBusDatastoreTest do
  use ExUnit.Case
  doctest EventBusDatastore

  test "greets the world" do
    assert EventBusDatastore.hello() == :world
  end
end
