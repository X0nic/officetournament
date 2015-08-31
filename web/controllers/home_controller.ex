defmodule Officetournament.HomeController do
  use Officetournament.Web, :controller

  alias Officetournament.Home

  plug :scrub_params, "home" when action in [:create, :update]

  def index(conn, _params) do
    conn
    |> assign(:username, get_session(conn, :username))
    |> assign(:message, "this is a message")
    |> render("index.html")
  end
end
