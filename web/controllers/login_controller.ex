defmodule Officetournament.LoginController do
  use Officetournament.Web, :controller

  alias Officetournament.Login

  plug :scrub_params, "login" when action in [:create, :update]
  plug :action

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def login(conn, %{"login" => %{"username" => username, "password" => password}}) do
    conn
    |> put_flash(:info, "Welcome #{username}! I like your password #{password}")
    |> redirect(to: login_path(conn, :index))
  end

  def login(conn, params) do
    conn
    |> put_flash(:info, "Access Denied")
    |> render "unauthorized.html"
  end
end
