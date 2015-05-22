defmodule Officetournament.HomeController do
  use Officetournament.Web, :controller

  alias Officetournament.Home

  plug :scrub_params, "home" when action in [:create, :update]
  plug :action

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
