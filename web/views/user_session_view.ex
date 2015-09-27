defmodule Officetournament.UserSessionView do
  use Officetournament.Web, :view

  def link_to(path, text) do
    raw "<a class=\"btn btn--google\" href=\"#{path}\">#{text}</a>"
  end
end
