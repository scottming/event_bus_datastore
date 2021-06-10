defmodule EventBusDatastore.Store do
  @moduledoc """
  Basic db actions. Stolen from here: 
  https://github.com/otobus/event_bus_postgres/blob/main/lib/event_bus_postgres/store.ex

  """

  import Ecto.Query

  alias EventBusDatastore.Schemas.Event

  @pagination_vars %{page: 1, per_page: 20, since: 0}
  @pagination_vars_with_transaction_id Map.put(@pagination_vars, :transaction_id, nil)
  @repo Application.get_env(:event_bus_datastore, :repo)

  @doc """
  Fetch all events with pagination
  """
  def all(%{page: page, per_page: per_page, since: since} \\ @pagination_vars) do
    offset = (page - 1) * per_page

    query =
      from(
        e in Event,
        where: e.occurred_at >= ^since,
        offset: ^offset,
        limit: ^per_page
      )

    query
    |> @repo.all()
    |> Enum.map(fn event -> Event.to_eb_event(event) end)
  end

  @doc """
  Total events per topic since given time
  """
  def count_per_topic(%{since: since} \\ %{since: 0}) do
    query =
      from(
        e in Event,
        where: e.occurred_at >= ^since,
        group_by: e.topic,
        select: %{topic: e.topic, count: count(e.id)}
      )

    @repo.all(query)
  end

  @doc """
  Total events since given time
  """
  def count(%{since: since} \\ %{since: 0}) do
    query =
      from(
        e in Event,
        where: e.occurred_at >= ^since
      )

    @repo.aggregate(query, :count, :id)
  end

  @doc """
  Find all events with pagination
  """
  def find_all_by_transaction_id(
        %{page: page, per_page: per_page, since: since, transaction_id: transaction_id} \\ @pagination_vars_with_transaction_id
      ) do
    query =
      from(
        e in Event,
        where:
          e.transaction_id == ^transaction_id and
            e.occurred_at >= ^since,
        offset: ^((page - 1) * per_page),
        limit: ^per_page
      )

    query
    |> @repo.all()
    |> Enum.map(fn event -> Event.to_eb_event(event) end)
  end

  @doc """
  Find an event
  """
  def find(id) do
    case @repo.get(Event, id) do
      nil -> nil
      event -> Event.to_eb_event(event)
    end
  end

  @doc """
  Delete an event
  """
  def delete(id) do
    @repo.delete(%Event{id: id})
  end

  @doc """
  Batch insert
  """
  def batch_insert([]) do
    :ok
  end

  def batch_insert(events) do
    @repo.insert_all(Event, events, on_conflict: :nothing)
  end

  @doc """
  Delete expired events
  """
  def delete_expired do
    now = System.os_time(:microsecond)

    query =
      from(
        e in Event,
        where: fragment("? + ? >= ?", e.occurred_at, e.ttl, ^now)
      )

    @repo.delete_all(query)
  end
end

