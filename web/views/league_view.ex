defmodule Officetournament.LeagueView do
  use Officetournament.Web, :view
  alias Officetournament.ViewHelper

  def render("_header.html", assigns) do
    inner_html = render("_header_back.html", assigns)
    render("header.html", Dict.put(assigns, :inner_html, inner_html))
  end

  def render("header_new.html", assigns) do
    inner_html = render("_header_new.html", assigns)
    render("header.html", Dict.put(assigns, :inner_html, inner_html))
  end

  def render("header_join.html", assigns) do
    inner_html = render("_header_join.html", assigns)
    render("header.html", Dict.put(assigns, :inner_html, inner_html))
  end

  def render("header.html", assigns) do
    Officetournament.SharedView.render("_header.html", assigns)
  end
end
