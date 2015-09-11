# Mostly taken from http://stackoverflow.com/a/31983168/3453
defmodule Officetournament.Plugs.Authenticate do
  import Plug.Conn
  alias Officetournament.Router.Helpers, as: RouteHelpers
  import Phoenix.Controller

  alias Officetournament.Repo
  alias Officetournament.User

  def init(opts), do: opts

  def call(conn, _default) do
    case current_user(conn) do
      nil -> auth_error!(conn)
      _   -> conn
    end
  end

  @doc "Returns the current user."
  def current_user(conn), do: conn.assigns[:current_user]

  @doc "Returns true if a user is logged in."
  def logged_in?(conn), do: !is_nil current_user(conn)

  def get_user(conn) do
    case conn.assigns[:current_user] do
      nil      -> fetch_user(conn)
      user     -> user
    end
  end

  defp auth_error!(conn) do
    conn
    |> put_flash(:error, "You need to be signed in to view this page")
    |> redirect(to: RouteHelpers.user_session_path(conn, :index))
    |> halt
  end
end
