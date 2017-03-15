defmodule Ecto.South.Migrations do
  @data_path "./priv/repo/migrations.exs"
  @migrate_path "./priv/repo/migrations"
  @mods  Application.get_env(:ecto_south, :mods) || []

  #all models
  def mods(), do: Application.get_env(:ecto_south, :mods) || []
  def old_data() do
    try do
      Code.eval_file(@data_path)
      Ecto.South.Migrations.Data.show()
    catch
      _,_ ->  false
    end
  end

  def run() do
    old = old_data()
    new = meta_mod_all(@mods)
    unless old do
      diff(new, %{})
      init_migrations_file()
    else
      if old == new do
        Mix.shell.info "No changes detected \n"
      else
        Mix.shell.info "Has changes, checking....\n"
        diff(new, old)
        init_migrations_file()
      end
    end
  end

  def meta_mod(mod) do
    types = Enum.reduce(mod.__schema__(:associations), mod.__schema__(:types), fn(ref, acc) ->
      ass = mod.__schema__(:association, ref)
      type = String.to_atom "ref__#{ass.related.__schema__(:source)}"
      Map.put acc, ass.owner_key, type
    end)
    %{
      types: types,
      primary_key: mod.__schema__(:primary_key)
    }
  end

  def meta_mod_all(mods) do
    Enum.reduce(mods, %{}, fn(m, acc) ->
      Map.put acc, m.__schema__(:source), meta_mod(m)
    end)
  end

  def diff(new, old) do
    changes = for {k, v} <- Enum.to_list(new) do
      unless old[k] == v do
        unless old[k], do: create_table(k, v), else: check_field(k, v, old[k])
      end
    end
    changes_drop = for {k, _} <- Enum.to_list(old) do
      unless new[k], do: drop_table(k)
    end
    change_data = Enum.filter(changes ++ changes_drop, fn x -> x != nil end)
    show_change(change_data)

    content = Ecto.South.Migrate.Template.get(change_data)
    file_name = "/#{string_time_now()}_south.exs"
    File.write(@migrate_path <> file_name, content)
  end

  def string_time_now() do
    d = DateTime.utc_now
    month = if d.month < 10, do: "0#{d.month}", else: d.month
    day = if d.day < 10, do: "0#{d.day}", else: d.day
    hour = if d.hour < 10, do: "0#{d.hour}", else: d.hour
    minute = if d.minute < 10, do: "0#{d.minute}", else: d.minute
    second = if d.second < 10, do: "0#{d.second}", else: d.second
    "#{d.year}#{month}#{day}#{hour}#{minute}#{second}"
  end

  # change = %{action: atom, table: atom, schema: [%{action: atom, filed: atom, type: atom }]}
  def create_table(table, data) do
    change_field = for {k, v} <- Enum.to_list(data[:types]) do
      %{action: :add, filed: k, type: v}
    end
    %{table: table, action: :create, schema: change_field}
  end

  def drop_table(table), do: %{table: table, action: :drop}

  def check_field(table, new_data, old_data) do
    new = new_data[:types]
    old = old_data[:types]
    change_add = Enum.reduce(Enum.to_list(new), [], fn({f, t}, acc) ->
      unless old[f], do: acc ++ [%{action: :add, filed: f, type: t}], else: acc
    end)
    change_delete = Enum.reduce(Enum.to_list(old), [], fn({f, _}, acc) ->
      unless new[f], do: acc ++ [%{action: :remove, filed: f}], else: acc
    end)
    %{table: table, action: :alter, schema: change_add ++ change_delete}
  end

  def show_change(data) do
    for i <- data do
      Mix.shell.info "table: #{i.table}, action: #{i.action}"
      if i[:schema] do
        for s <- i.schema do
          if s[:type] do
            Mix.shell.info "    #{s.action}: #{s.filed}, :#{s.type}"
          else
            Mix.shell.info "    #{s.action}: #{s.filed}"
          end
        end
      end
      IO.puts ""
    end
  end

  def init_migrations_file() do
    content = @mods |> meta_mod_all() |> Ecto.South.Migrations.Template.get
    File.write(@data_path, content)
  end
end
