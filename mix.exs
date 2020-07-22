defmodule CapturePipe.MixProject do
  use Mix.Project

  @source_url "https://github.com/Qqwy/elixir-capture_pipe"

  def project do
    [
      app: :capture_pipe,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      name: "CapturePipe",
      package: package(),
      source_url: @source_url,
      homepage_url: "https://github.com/Qqwy/elixir-capture_pipe",
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
    ]
  end


  defp description do
    """
    CapturePipe exposes an extended pipe-operator that allows the usage of bare function captures.
    """
  end

  defp package do
    [
      name: :capture_pipe,
      files: ["lib", "mix.exs", "README*", "LICENSE"],
      maintainers: ["Wiebe-Marten Wijnja/Qqwy"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end
end
