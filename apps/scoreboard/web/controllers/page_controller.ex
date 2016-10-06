defmodule Scoreboard.PageController do
  use Scoreboard.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
