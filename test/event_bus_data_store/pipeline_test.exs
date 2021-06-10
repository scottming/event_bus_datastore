defmodule EventBusDatastore.PipelineTest do
  use ExUnit.Case, async: true

  @tag :unit
  test "message" do
    ref = Broadway.test_message(EventBusDatastore.Pipeline, 1)
    assert_receive {:ack, ^ref, [%{data: 1}], []}
  end
end

