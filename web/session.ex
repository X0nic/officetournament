defmodule Officetournament.Session do
  def assign_user(conn, user_id) when is_integer(user_id) do
    case User.Query.by_id(user_id) do
      nil -> conn
      user -> assign_user(conn, user)
    end
  end

  def assign_user(conn, user) when is_map(user) do
    Plug.Conn.assign(conn, @user_key, user)
  end
end
