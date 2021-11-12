defmodule ApplicantTrackingWeb.PageController do
  use ApplicantTrackingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
