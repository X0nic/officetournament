defmodule Officetournament.Router do
  use Officetournament.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Officetournament do
    pipe_through :browser # Use the default browser stack

    get "/", HomeController, :index
    get "/login/", UserSessionController, :index
    post "/login/", UserSessionController, :login
    get "/logout/", UserSessionController, :logout
    resources "/leagues", LeagueController
    post "/leagues/:id/join", LeagueController, :join
  end

  scope "/admin", as: :admin do
    pipe_through :browser # Use the default browser stack

    resources "/users", Officetournament.Admin.UserController
    resources "/leagues", Officetournament.Admin.LeagueController
  end

  scope "/auth", Officetournament do
    pipe_through :browser

    get "/:provider", AuthController, :index
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", Officetournament do
  #   pipe_through :api
  # end

  # https://github.com/rrrene/elixirstatus-web/blob/07ca31cd035e67666a598589b7f4490846dfc9d8/web/router.ex
  # Fetch the current user from the session and add it to `conn.assigns`. This
  # will allow you to have access to the current user in your views with
  # `@current_user`.
  defp assign_current_user(conn, _) do
    user_id = get_session(conn, :current_user_id)
    assign(conn, :current_user, Officetournament.UserSessionController.find_by_id(user_id))
  end
end
