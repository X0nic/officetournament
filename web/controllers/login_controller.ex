defmodule Officetournament.LoginController do
  use Officetournament.Web, :controller

  alias Officetournament.Login

  plug :scrub_params, "login" when action in [:create, :update]
  plug :action

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def login(conn, _params) do
    conn
    |> put_flash(:info, "Login Sucessfull")
    |> redirect(to: login_path(conn, :index))
  end
end
