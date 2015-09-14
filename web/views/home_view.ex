defmodule Officetournament.HomeView do
  use Officetournament.Web, :view

  def logged_in?(conn), do: Authenticate.logged_in?(conn)
end
