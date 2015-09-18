defmodule Officetournament.HomeController do
  use Officetournament.Web, :controller

  alias Officetournament.Home
  plug Officetournament.Plugs.Authenticate

  plug :scrub_params, "home" when action in [:create, :update]

  def index(conn, _params) do
    conn
    |> render("index.html")
  end
end
