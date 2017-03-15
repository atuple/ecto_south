defmodule Ecto.South.Mixfile do
  use Mix.Project

  def project do
    [app: :ecto_south,
     version: "0.1.4",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     # Hex
     description: description(),
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger, :ecto]]
  end

  defp deps do
    [
      {:ecto, ">= 2.0.0"},
      {:ex_doc, ">= 0.0.0", only: [:dev, :test]}
    ]
  end

  defp description() do
    "South brings ecto migrations to phoenix applications"
  end

  defp package do
    [maintainers: ["ntsai",],
     licenses: ["MIT"],
     links: %{github: "https://github.com/360ekh/ecto_south"},
     files: ~w(lib README.md mix.exs LICENSE)]
  end
end
