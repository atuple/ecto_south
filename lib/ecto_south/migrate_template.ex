defmodule Ecto.South.Migrate.Template do
  def template do
    """
    defmodule Repo.Migrations.Auto do
      use Ecto.Migration
      def change do
        <%= for i <- data do %>
            <%= if i.action != :drop do %><%= i.action %> table(:<%= i.table %>) do <%= for s <- i.schema do %>
              <%= s %><% end %>
            end
          <% else %>drop table(:<%= i.table %>)
          <% end %><% end %>
      end
    end
    """
  end

  def get(data \\ []) do
    tpl_data = to_tpl(data)
    EEx.eval_string(template(), [data: tpl_data])
  end

  def to_tpl(data) do
    for i <- data, do: to_block_data(i)
  end


  def to_block_data(data) do
    if data.action != :drop do
      action_change(data)
    else
      %{action: data.action, table: data.table}
    end
  end

  @timestamps_atom [:inserted_at, :updated_at]
  def action_change(data) do
    timestamps? = Enum.reduce(data.schema, [], fn(i, acc) ->
      if i.filed in @timestamps_atom  do
        acc ++ [i.filed]
      else
        acc
      end
    end)

    schema_data = if timestamps? == @timestamps_atom do
      Enum.reduce(data.schema, [], fn(i, acc) ->
        if i.filed in @timestamps_atom || i[:type] == :id do
          acc
        else
          acc ++ [i]
        end
      end)
    else
       Enum.filter(data.schema, fn(i) -> i[:type] != :id end)
    end

    schema = for i <- schema_data do
      if i.action != :remove do
        "#{i.action} :#{i.filed},  #{format_type(i.type)}"
      else
        "#{i.action} :#{i.filed}"
      end
    end
    schema = if timestamps? == @timestamps_atom, do: schema ++ ["timestamps"], else: schema
    %{action: data.action, table: data.table, schema: schema}
  end


  @ecto_atom_type  [:string, :integer, :id, :float, :boolean, :binary]
  def format_type(t) do
    type = Atom.to_string(t)
    cond do
      t in @ecto_atom_type ->
        ":#{t}"

      String.contains?(type, "ref__") ->
        [_, ref] = String.split(type, "ref__")
        "references(:#{ref})"

      t == Ecto.Date ->
        ":date"

      t == Ecto.DateTime ->
        ":naive_datetime"

      t == Ecto.Time ->
        ":time"

      true ->
        ":#{t}"
    end
  end

end
