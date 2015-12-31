defmodule Officetournament.UserSessionControllerTest do
  use Officetournament.ConnCase

  alias Officetournament.User
  @valid_params user: %{email: "some content", name: "some content", username: "username"}
  @invalid_params user: %{name: "just a name"}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "Login with a valid user", %{conn: conn} do
    conn = post conn, user_path(conn, :create), @valid_params
    assert redirected_to(conn) == user_path(conn, :index)
  end
end
