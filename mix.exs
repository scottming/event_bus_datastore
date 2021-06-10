defmodule EventBusDatastore.MixProject do
  use Mix.Project

  def project do
    [
      app: :event_bus_datastore,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    case Mix.env() do
      # In test we start an application to test the Ecto Repo integration
      :test ->
        [
          mod: {TestApp, []},
          extra_applications: [:logger, :runtime_tools, :broadway, :event_bus]
        ]

      _ ->
        [
          extra_applications: [:logger, :broadway, :event_bus],
          mod: {EventBusDatastore.Application, []}
        ]

        # [extra_applications: [:logger]]
    end

    # [
    #   extra_applications: [:logger],
    #   mod: {EventBusDatastore.Application, []}
    # ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:gen_stage, "~> 1.0"},
      {:postgrex, ">= 0.13.3"},
      {:ecto, "~> 3.0"},
      {:ecto_sql, "~> 3.0", only: :test},
      {:broadway, "~> 0.6.0"},
      {:event_bus, "~> 1.6.2"},
      {:elixir_uuid, "~> 1.2"}
    ]
  end
end

