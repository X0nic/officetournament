defmodule Officetournament.UserControllerTest do
  use Officetournament.ConnCase

  alias Officetournament.User
  alias Officetournament.Router
  alias Officetournament.Session
  alias Officetournament.Endpoint
  @valid_params user: %{email: "some content", name: "some content", username: "username"}
  @invalid_params user: %{name: "just a name"}

  @opts Router.init([])

  @session Plug.Session.init(
    store: :cookie,
    key: "_app",
    signing_salt: "yadayada"
  )

  def with_session(conn, opts) do
    conn
    |> Map.put(:secret_key_base, String.duplicate("abcdefgh", 8))
    |> Plug.Session.call(@session)
    |> Plug.Conn.fetch_session()
    |> fetch_flash
    |> assign_flash(opts)
  end

  def send_request(action, path, params \\ %{}, opts \\ %{}) do
    build_request(action, path, params, opts)
    |> Endpoint.call([])
  end

  def build_request(action, path, params \\ %{}, opts \\ %{}) do
    conn(action, path, params)
    |> with_session(opts)
    |> assign_session(opts)
    |> assign_user(opts)
    |> put_private(:plug_skip_csrf_protection, true)
  end

  def send_request_with_response(action, path, params \\ %{}, opts \\ %{}) do
    build_request(action, path, params, opts)
    |> send_resp(200, "ok")
  end

  def assign_session(conn, opts) do
    session = opts[:session]
    case session do
      nil -> conn
      session -> conn |> put_session(session[:key], session[:value])
    end
  end

  def assign_flash(conn, opts) do
    flash = opts[:flash]
    case flash do
      nil -> conn
      flash -> conn |> put_flash(flash[:type], flash[:message])
    end
  end

  def assign_user(conn, opts \\ %{}) do
    case opts[:as] do
      nil -> conn
      user -> Session.assign_user(conn, user)
    end
  end

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "GET /users", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing users"
  end

  test "GET /users/new", %{conn: conn} do
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "New user"
  end

  test "POST /users with valid data", %{conn: conn} do
    conn = post conn, user_path(conn, :create), @valid_params
    assert redirected_to(conn) == user_path(conn, :index)
  end

  test "POST /users with invalid data", %{conn: conn} do
    conn = post conn, user_path(conn, :create), @invalid_params
    assert html_response(conn, 200) =~ "New user"
  end

  test "GET /users/:id", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :show, user)
    assert html_response(conn, 200) =~ "Show user"
  end

  test "GET /users/:id/edit", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :edit, user)
    assert html_response(conn, 200) =~ "Edit user"
  end

  test "PUT /users/:id with valid data", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put conn, user_path(conn, :update, user), @valid_params
    assert redirected_to(conn) == user_path(conn, :show, user)
  end

  test "PUT /users/:id with invalid data", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put conn, user_path(conn, :update, user), @invalid_params
    assert html_response(conn, 200) =~ "Edit user"
  end

  test "DELETE /users/:id", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = delete conn, user_path(conn, :delete, user)
    assert redirected_to(conn) == user_path(conn, :index)
    refute Repo.get(User, user.id)
  end

  test "should redirect to page if user is authenticated" do
    user = Repo.insert! %User{}
    response = send_request(:delete, user_path(conn, :delete, user), _params = %{}, as: user)
    assert redirected_to(response) == user_path(Endpoint, :index)
  end
end
