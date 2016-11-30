defmodule Learnrls.PageController do
  use Learnrls.Web, :controller
  require Logger

  def index(conn, _params) do
    Logger.info("Hello world")
    render conn, "index.html"
  end
end
