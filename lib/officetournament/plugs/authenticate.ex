# Mostly taken from http://stackoverflow.com/a/31983168/3453
defmodule Officetournament.Plugs.Authenticate do
  import Plug.Conn
  alias Officetournament.Router.Helpers, as: RouteHelpers
  import Phoenix.Controller

  alias Officetournament.Repo
  alias Officetournament.User

  def init(opts), do: opts

  def call(conn, _opts) do
    if user = get_user(conn) do
      assign(conn, :current_user, user)
    else
      auth_error!(conn)
    end
  end

  def get_user(conn) do
    case conn.assigns[:current_user] do
      nil      -> fetch_user(conn)
      user     -> user
    end
  end

  defp fetch_user(conn) do
    case get_session(conn, :current_user) do
      {:ok, user} -> user
      _           -> nil
    end
  end

  defp find_user(id) do
    Repo.get(User, id)
  end

  defp auth_error!(conn) do
    conn
    |> put_flash(:error, "You need to be signed in to view this page")
    |> redirect(to: RouteHelpers.user_session_path(conn, :index))
    |> halt
  end
end
