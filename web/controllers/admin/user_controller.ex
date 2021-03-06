defmodule Officetournament.Admin.UserController do
  use Officetournament.Web, :controller

  alias Officetournament.User

  plug :scrub_params, "user" when action in [:create, :update]
  plug Officetournament.Plugs.Authenticate
  plug :set_layout

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    hash_password = Comeonin.Bcrypt.hashpwsalt(user_params["password"])

    changeset = User.changeset(%User{}, %{ user_params | "password" => hash_password} )

    if changeset.valid? do
      Repo.insert(changeset)

      conn
      |> put_flash(:info, "User created successfully.")
      |> redirect(to: admin_user_path(conn, :index))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    hash_password = Comeonin.Bcrypt.hashpwsalt(user_params["password"])

    user = Repo.get(User, id)
    changeset = User.changeset(user, %{ user_params | "password" => hash_password} )

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: admin_user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
    # if changeset.valid? do
    #   Repo.update(changeset)
    #
    #   conn
    #   |> put_flash(:info, "User updated successfully.")
    #   |> redirect(to: admin_user_path(conn, :index))
    # else
    #   render(conn, "edit.html", user: user, changeset: changeset)
    # end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    Repo.delete(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: admin_user_path(conn, :index))
  end

  defp set_layout(conn, _default) do
    conn
      |> put_layout("admin.html")
  end
end
