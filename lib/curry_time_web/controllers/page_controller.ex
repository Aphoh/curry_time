defmodule CurryTimeWeb.PageController do
  use CurryTimeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
