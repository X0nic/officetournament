defmodule Officetournament.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Officetournament.Web, :controller
      use Officetournament.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Model
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      alias Officetournament.Repo
      import Ecto.Model
      import Ecto.Query, only: [from: 1, from: 2]

      alias Officetournament.Plugs.Authenticate

      import Officetournament.Router.Helpers
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"
      # require Logger

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import Officetournament.Form

      import Officetournament.Router.Helpers

      alias Officetournament.Plugs.Authenticate

      def logged_in?(conn), do: Authenticate.logged_in?(conn)

      def active(option, conn) do
        # Logger.debug "We are at path #{conn.request_path} for option #{option}"

        if option == conn.request_path do
          # Logger.debug "We are active"
          " class=\"active\""
        else
          # Logger.debug "We are not active"
          ""
        end
      end
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias Officetournament.Repo
      import Ecto.Model
      import Ecto.Query, only: [from: 1, from: 2]

    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
