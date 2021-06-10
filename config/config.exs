use Mix.Config

# only for test
postgrex_config = [
  username: "postgres",
  password: "postgres",
  database: "event_bus_db",
  hostname: "127.0.0.1",
  port: 5432
]

config :event_bus_datastore,
  events_table_name: "event_bus_events",
  postgrex: postgrex_config,
  debug: true

# config :logger, level: :debug
config :logger, level: :warn

if Mix.env() == :test do
  config :event_bus_datastore, ecto_repos: [TestApp.Repo]
  config :event_bus_datastore, TestApp.Repo, postgrex_config
  config :event_bus_datastore, repo: TestApp.Repo
end

if File.exists?("config/local.exs") do
  import_config "local.exs"
end
