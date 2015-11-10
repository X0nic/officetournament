defmodule Officetournament.ViewHelper do
  use Officetournament.Web, :view

  alias Officetournament.User

  def avatar_path(%User{avatar_url: avatar_url, provider: provider}), do: avatar_path(provider, avatar_url)

  def avatar_path("github", avatar_url) when is_binary(avatar_url) do
    avatar_url
    |> String.replace("?v=3", "?v=3&s=180")
  end

  def avatar_path("google", avatar_url) when is_binary(avatar_url) do
    avatar_url
    |> String.replace("?sz=50", "?sz=180")
  end

  def avatar_path(_, nil), do: nil
end
