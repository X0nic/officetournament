defmodule Officetournament.HomeView do
  use Officetournament.Web, :view

  def render("_header.html", assigns) do
    inner_html = render("_header_create.html", assigns)
    Officetournament.SharedView.render("_header.html", Dict.put(assigns, :inner_html, inner_html))
  end
end
