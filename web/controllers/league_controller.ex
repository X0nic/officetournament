defmodule Officetournament.LeagueController do
  use Officetournament.Web, :controller

  alias Officetournament.League
  alias Officetournament.Membership

  plug :scrub_params, "league" when action in [:create, :update]
  plug Officetournament.Plugs.Authenticate

  def index(conn, _params) do
    leagues = Repo.all(League)
    render(conn, "index.html", leagues: leagues)
  end

  def new(conn, _params) do
    changeset = League.changeset(%League{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"league" => league_params}) do
    changeset = League.changeset(%League{}, league_params)

    case Repo.insert(changeset) do
      {:ok, _league} ->
        conn
        |> put_flash(:info, "League created successfully.")
        |> redirect(to: home_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    league = Repo.get!(League, id) |> Repo.preload(:users)
    render(conn, "show.html", league: league)
  end

  def edit(conn, %{"id" => id}) do
    league = Repo.get!(League, id)
    changeset = League.changeset(league)
    render(conn, "edit.html", league: league, changeset: changeset)
  end

  def update(conn, %{"id" => id, "league" => league_params}) do
    league = Repo.get!(League, id)
    changeset = League.changeset(league, league_params)

    case Repo.update(changeset) do
      {:ok, league} ->
        conn
        |> put_flash(:info, "League updated successfully.")
        |> redirect(to: league_path(conn, :show, league))
      {:error, changeset} ->
        render(conn, "edit.html", league: league, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    league = Repo.get!(League, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(league)

    conn
    |> put_flash(:info, "League deleted successfully.")
    |> redirect(to: league_path(conn, :index))
  end

  def join(conn, %{"id" => id}) do
    changeset = Membership.changeset(%Membership{}, %{"league_id" => id, "user_id" => Authenticate.current_user(conn).id})

    case Repo.insert(changeset) do
      {:ok, _membership} ->
        conn
        |> put_flash(:info, "You have joined the league sucessfully")
        |> redirect(to: home_path(conn, :index))
      {:error, results} ->
        conn
        |> put_flash(:error, friendly_error_message(results) )
        |> redirect(to: home_path(conn, :index))
        # render(conn, "new.html", changeset: changeset)
    end
  end

  defp friendly_error_message( %{ errors: [ league_id: _ ] } ) do
   "You have already joined this league"
  end

  defp friendly_error_message(_) do
   "Error joining league"
  end
end
