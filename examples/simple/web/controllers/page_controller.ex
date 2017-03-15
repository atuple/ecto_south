defmodule Simple.PageController do
  use Simple.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
