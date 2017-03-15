defmodule Simple.Weather do
  use Simple.Web, :model

  schema "weather" do
    field :city, :string
    field :temp_lo, :integer
    field :temp_hi, :integer
    field :prcp, :float, default: 0.0
    timestamps
  end
end
