defmodule Officetournament.UserSessionController do
  use Officetournament.Web, :controller
  require Logger

  alias Officetournament.Login
  alias Officetournament.User

  plug :scrub_params, "login" when action in [:create, :update]

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def login(conn, %{"login" => %{"username" => username, "password" => password}}) do
    user = find_user_and_pass(username, password)

    if user do
      conn
      |> put_flash(:info, "Welcome #{user.username}! I like your password #{password}")
      |> put_session(:current_user_id, user.id)
      |> redirect(to: user_session_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Username and password not found.")
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

  defp find_user_and_pass(username, password) do
    Logger.debug "Found username: #{username} password: #{password}"

    user = Repo.one(from u in User,
                    where: u.username == ^username,
                    select: u)

    if !is_nil(user) do
      Logger.debug "Testing #{user.username}:#{user.password}"
    end

    if check_password(user, password) do
      user
    else
      nil
    end
  end

  defp check_password(nil, password) do
    nil
  end

  defp check_password(user, password) do
    Logger.debug "Checking password: #{password}"

    Comeonin.Bcrypt.checkpw(password, user.password)
  end
end
