defmodule Officetournament.UserSessionView do
  use Officetournament.Web, :view

  def link_to(path, text) do
    raw "<a href=\"#{path}\">#{text}</a>"
  end

  def link_to(path, text, %{class: class_name}) do
    raw "<a class=\"#{class_name}\" href=\"#{path}\">#{text}</a>"
  end
end
