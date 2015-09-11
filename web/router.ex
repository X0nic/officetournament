defmodule Officetournament.Router do
  use Officetournament.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
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
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Officetournament do
  #   pipe_through :api
  # end
end
