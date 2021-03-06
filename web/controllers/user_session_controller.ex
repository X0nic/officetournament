defmodule Officetournament.UserSessionController do
  use Officetournament.Web, :controller
  require Logger

  alias Officetournament.User

  plug :scrub_params, "login" when action in [:create, :update]

  def index(conn, _params) do
    if Authenticate.logged_in?(conn) do
      conn
      |> redirect(to: home_path(conn, :index))
    else
      conn
      |> put_layout("login.html")
      |> render("index.html")
    end
  end

  def login(conn, %{"login" => %{"username" => username, "password" => password}}) do
    user = find_user_and_pass(username, password)

    if user do
      conn
      |> put_flash(:info, "Welcome #{user.username}!")
      |> put_session(:current_user_id, user.id)
      |> redirect(to: home_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Username and password not found.")
      |> redirect(to: user_session_path(conn, :index))
    end
  end

  def login(conn, _params) do
    conn
    |> put_layout(false)
    |> put_status(401)
    |> render "unauthorized.html"
  end

  def logout(conn, _params) do
    conn
    |> clear_session
    |> put_flash(:info, "You have been logged out.")
    |> redirect(to: home_path(conn, :index))
  end

  def find_by_id(user_id) do
    case user_id do
      nil -> nil
      _ -> Repo.get(User, user_id)
    end
  end

  defp find_user_and_pass(username, password) do
    user = Repo.one(from u in User,
                    where: u.username == ^username,
                    select: u)

    if check_password(user, password) do
      user
    else
      nil
    end
  end

  def create_from_auth_params("github", user_auth_params) do
    %User{
      name: user_auth_params["name"],
      username: user_auth_params["login"],
      email: user_auth_params["email"],
      avatar_url: user_auth_params["avatar_url"],
      provider: "github"
    } |> Repo.insert!
  end

  def create_from_auth_params("google", user_auth_params) do
    %User{
      email: user_auth_params["email"],
      name: user_auth_params["name"],
      avatar_url: user_auth_params["picture"],
      provider: "google"
    } |> Repo.insert!
  end

  def find_by_user_params("github", user_params) do
    %OAuth2.Response{body: %{"login" => username} } = user_params
    query = from u in User,
            where: u.username == ^username and u.provider == ^"github",
            select: u
    Repo.one(query)
  end

  def find_by_user_params("google", user_params) do
    %OAuth2.Response{body: %{"email" => email} } = user_params
    query = from u in User,
            where: u.email == ^email and u.provider == ^"google",
            select: u
    Repo.one(query)
  end

  defp check_password(nil, _password) do
    nil
  end

  defp check_password(user, password) do
    Comeonin.Bcrypt.checkpw(password, user.password)
  end
end
