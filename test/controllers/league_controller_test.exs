defmodule Officetournament.LeagueControllerTest do
  use Officetournament.ConnCase

  alias Officetournament.League
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, league_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing leagues"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, league_path(conn, :new)
    assert html_response(conn, 200) =~ "New league"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, league_path(conn, :create), league: @valid_attrs
    assert redirected_to(conn) == league_path(conn, :index)
    assert Repo.get_by(League, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, league_path(conn, :create), league: @invalid_attrs
    assert html_response(conn, 200) =~ "New league"
  end

  test "shows chosen resource", %{conn: conn} do
    league = Repo.insert! %League{}
    conn = get conn, league_path(conn, :show, league)
    assert html_response(conn, 200) =~ "Show league"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, league_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    league = Repo.insert! %League{}
    conn = get conn, league_path(conn, :edit, league)
    assert html_response(conn, 200) =~ "Edit league"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    league = Repo.insert! %League{}
    conn = put conn, league_path(conn, :update, league), league: @valid_attrs
    assert redirected_to(conn) == league_path(conn, :show, league)
    assert Repo.get_by(League, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    league = Repo.insert! %League{}
    conn = put conn, league_path(conn, :update, league), league: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit league"
  end

  test "deletes chosen resource", %{conn: conn} do
    league = Repo.insert! %League{}
    conn = delete conn, league_path(conn, :delete, league)
    assert redirected_to(conn) == league_path(conn, :index)
    refute Repo.get(League, league.id)
  end
end
