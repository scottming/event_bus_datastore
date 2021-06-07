defmodule EventBusDatastore.Pipeline do
  use Broadway

  def start_link(opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {EventBusDatastore.Producer, opts},
        # We cannot have more than one producer with the same token.
        concurrency: 1
      ],
      processors: [
        default: [concurrency: 10]
      ],
      batchers: [
        default: [batch_size: 50, batch_timeout: 1000]
      ]
    )
  end

  @impl true
  def handle_message(_, message, _) do
    IO.puts("Got message: #{inspect(message)}")
    message
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    list = messages |> Enum.map(fn e -> e.data end)
    IO.puts("Got batch: #{inspect(list)}")
    messages
  end
end

