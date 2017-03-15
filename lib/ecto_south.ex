defmodule Ecto.South do
  @moduledoc """
  Documentation for EctoSouth.
  """

  def makemigrations() do
    Ecto.South.Migrations.run()
    :ok
  end

end
