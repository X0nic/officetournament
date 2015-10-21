defmodule Officetournament.LeagueView do
  use Officetournament.Web, :view

  def render("_header.html", assigns) do
    Officetournament.SharedView.render("_header.html", assigns)
  end
end
