defmodule Officetournament.HomeControllerTest do
  use Officetournament.ConnCase

  alias Officetournament.Home
  @valid_params home: %{}
  @invalid_params home: %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "GET /", %{conn: conn} do
    conn = get conn, home_path(conn, :index)
    assert html_response(conn, 200) =~ "Welcome home"
  end
end
