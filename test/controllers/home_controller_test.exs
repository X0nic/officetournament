defmodule Officetournament.HomeControllerTest do
  use Officetournament.ConnCase

  alias Officetournament.Home
  @valid_params home: %{}
  @invalid_params home: %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "GET /homes", %{conn: conn} do
    conn = get conn, home_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing homes"
  end

  test "GET /homes/new", %{conn: conn} do
    conn = get conn, home_path(conn, :new)
    assert html_response(conn, 200) =~ "New home"
  end

  test "POST /homes with valid data", %{conn: conn} do
    conn = post conn, home_path(conn, :create), @valid_params
    assert redirected_to(conn) == home_path(conn, :index)
  end

  test "POST /homes with invalid data", %{conn: conn} do
    conn = post conn, home_path(conn, :create), @invalid_params
    assert html_response(conn, 200) =~ "New home"
  end

  test "GET /homes/:id", %{conn: conn} do
    home = Repo.insert %Home{}
    conn = get conn, home_path(conn, :show, home)
    assert html_response(conn, 200) =~ "Show home"
  end

  test "GET /homes/:id/edit", %{conn: conn} do
    home = Repo.insert %Home{}
    conn = get conn, home_path(conn, :edit, home)
    assert html_response(conn, 200) =~ "Edit home"
  end

  test "PUT /homes/:id with valid data", %{conn: conn} do
    home = Repo.insert %Home{}
    conn = put conn, home_path(conn, :update, home), @valid_params
    assert redirected_to(conn) == home_path(conn, :index)
  end

  test "PUT /homes/:id with invalid data", %{conn: conn} do
    home = Repo.insert %Home{}
    conn = put conn, home_path(conn, :update, home), @invalid_params
    assert html_response(conn, 200) =~ "Edit home"
  end

  test "DELETE /homes/:id", %{conn: conn} do
    home = Repo.insert %Home{}
    conn = delete conn, home_path(conn, :delete, home)
    assert redirected_to(conn) == home_path(conn, :index)
    refute Repo.get(Home, home.id)
  end
end
