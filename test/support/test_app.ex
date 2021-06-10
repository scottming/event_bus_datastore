defmodule TestApp do
  defmodule Repo do
    use Ecto.Repo, otp_app: :event_bus_datastore, adapter: Ecto.Adapters.Postgres
  end

  use Application

  def start(_types, _args) do
    {:ok, _} = Application.ensure_all_started(:ecto)
    {:ok, _} = Application.ensure_all_started(:event_bus)

    EventBus.subscribe({EventBusDatastore, [".*"]})
    Supervisor.start_link([__MODULE__.Repo, EventBusDatastore.Pipeline], strategy: :one_for_one)
  end
end

