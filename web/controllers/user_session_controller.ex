defmodule Officetournament.UserSessionController do
  use Officetournament.Web, :controller

  alias Officetournament.Login
  alias Officetournament.User

  plug :find_user
  plug :scrub_params, "login" when action in [:create, :update]

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def login(conn, %{"login" => %{"username" => username, "password" => password}}) do
    # user = Repo.all(from u in User, 
    #                 where: u.username == ^username,
    #                 select: u)
    user = Repo.get_by(User, username: username)

    if user do
      conn
      |> put_flash(:info, "Welcome #{user.username}! I like your password #{password}")
      |> put_session(:username, username)
      |> put_session(:current_user_id, user.id)
      |> redirect(to: user_session_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Username not found.")
      |> redirect(to: user_session_path(conn, :index))
    end
  end

  def login(conn, params) do
    conn
    |> put_layout(false)
    |> put_status(401)
    |> render "unauthorized.html"
  end

  def logout(conn, params) do
    conn
    |> clear_session
    |> redirect(to: home_path(conn, :index))
  end

  def find_by_id(user_id) do
    case user_id do
      nil -> nil
      _ -> Repo.get(User, user_id)
    end
  end

  defp find_user(conn, params) do
    conn |> assign(:username, "This is a test")
  end
end
