defmodule Mix.Tasks.South do
    use Mix.Task

    def run(arg \\ []) do
      Mix.shell.cmd("mix run -e Ecto.South.Migrations.run", [])
    end
end
