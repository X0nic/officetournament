defmodule Officetournament.LeagueView do
  use Officetournament.Web, :view

  def render("_header.html", assigns) do
    inner_html = render("_header_back.html", assigns)
    Officetournament.SharedView.render("_header.html", Dict.put(assigns, :inner_html, inner_html))
  end

  def render("header_new.html", assigns) do
    inner_html = render("_header_new.html", assigns)
    Officetournament.SharedView.render("_header.html", Dict.put(assigns, :inner_html, inner_html))
  end
end
