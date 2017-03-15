defmodule Ecto.South.Migrations.Template do
  def template do
    """
    defmodule Ecto.South.Migrations.Data do
      def show do
        %{<%= for {k, v} <- data do %>
          "<%= k %>" => %{
            primary_key: [ <%= for primary_key <- v.primary_key do %> :<%= primary_key %>, <% end %> ],
            types: %{
              <%=  for {tk, tv} <- Enum.to_list(v.types) do %><%= if tv == Elixir.Ecto.DateTime ||  tv == Elixir.Ecto.Date ||  tv == Elixir.Ecto.Time do %><%= tk %>: <%= tv %>, <% else %> <%= tk %>: :<%= tv %>, <% end %><% end %>
            }
          },<% end %>
        }
      end
    end
    """
  end

  def get(data) do
    EEx.eval_string(template(), [data: Enum.to_list(data)])
  end

end


defmodule Ecto.South.Migrations.Data do
  def show(), do: false
end
