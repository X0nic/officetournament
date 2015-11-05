defmodule Officetournament.HomeController do
  use Officetournament.Web, :controller

  alias Officetournament.League
  plug Officetournament.Plugs.Authenticate

  plug :scrub_params, "home" when action in [:create, :update]

  def index(conn, _params) do
    leagues = Repo.all(League) |> Repo.preload(:memberships)
    conn
    |> render("index.html", leagues: leagues)
  end
end
