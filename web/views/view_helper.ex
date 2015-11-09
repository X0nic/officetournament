defmodule Officetournament.ViewHelper do
  use Officetournament.Web, :view

  alias Officetournament.User

  def avatar_path(%User{avatar_url: avatar_url}), do: avatar_path(avatar_url)

  def avatar_path(avatar_url) when is_binary(avatar_url) do
    avatar_url
  end

  def avatar_path(nil), do: nil
end
