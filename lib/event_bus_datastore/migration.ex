defmodule EventBusDatastore.Migration do
  defmacro __using__(opts) do
    table_name =
      Keyword.get(opts, :table_name, EventBusDatastore.Config.events_table_name())
      |> to_string
      |> String.to_atom()

    quote do
      use Ecto.Migration

      def up do
        Enum.each(
          EventBusDatastore.Migration.statements(unquote(table_name)),
          fn statement ->
            execute(statement)
          end
        )
      end

      def down do
        Enum.each(
          EventBusDatastore.Migration.drop_statements(unquote(table_name)),
          fn statement ->
            execute(statement)
          end
        )
      end
    end
  end

  def statements(table_name \\ EventBusDatastore.Config.events_table_name()) do
    [
      """
        create table #{table_name}
        (
        id uuid not null constraint #{table_name}_pkey primary key,
        transaction_id uuid,
        topic          varchar(255),
        data           bytea,
        initialized_at bigint,
        occurred_at    bigint,
        source         varchar(255),
        ttl            integer
        );
      """,
      """
      create index #{table_name}_occurred_at_DESC_index on #{table_name} (occurred_at desc);
      """,
      """
      create index #{table_name}_topic_index on #{table_name} (topic);
      """,
      """
      create index #{table_name}_transaction_id_index on #{table_name} (transaction_id);
      """
    ]
  end

  def drop_statements(table_name \\ EventBusDatastore.Config.events_table_name()) do
    [
      """
      DROP TABLE IF EXISTS "#{table_name}";
      """,
      """
      DROP SEQUENCE IF EXISTS #{table_name}_id_seq;
      """
    ]
  end
end

