defmodule Officetournament.LoginController do
  use Officetournament.Web, :controller

  alias Officetournament.Login
  alias Officetournament.User


  plug :scrub_params, "login" when action in [:create, :update]
  plug :action

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def login(conn, %{"login" => %{"username" => username, "password" => password}}) do
    # query= from u in User
    #        where: u.username = username

    user = Repo.get_by(User, username: username)

    if user do
      conn
      |> put_flash(:info, "Welcome #{user.username}! I like your password #{password}")
      |> redirect(to: login_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Username not found.")
      |> redirect(to: login_path(conn, :index))
    end
  end

  def login(conn, params) do
    conn
    |> put_layout(false)
    |> put_status(401)
    |> render "unauthorized.html"
  end
end
