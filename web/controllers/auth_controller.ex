defmodule Officetournament.AuthController do
  use Officetournament.Web, :controller
  require Logger

  @doc """
  This action is reached via `/auth/:provider` and redirects to the OAuth2 provider
  based on the chosen strategy.
  """
  def index(conn, %{"provider" => provider}) do
    redirect conn, external: authorize_url!(provider)
  end

  @doc """
  This action is reached via `/auth/:provider/callback` is the the callback URL that
  the OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"provider" => provider, "code" => code}) do
    # Exchange an auth code for an access token
    token = get_token!(provider, code)

    # Request the user's data with the access token
    user_params = get_user!(provider, token)

    sign_in_via_auth conn, provider, user_params
  end

  defp sign_in_via_auth(conn, provider, user_auth_params) do
    current_user = find_or_create_user(provider, user_auth_params)

    conn
      |> put_session(:current_user_id, current_user.id)
      |> redirect(to: "/")
  end

  def find_or_create_user(provider, user_auth_params) do
    # try do
    #   ElixirStatus.Avatar.load! user_name, url
    # rescue
    #   e -> IO.inspect {"error", e}
    # end

    case Officetournament.UserSessionController.find_by_user_params(provider, user_auth_params) do
      nil -> Officetournament.UserSessionController.create_from_auth_params(provider, user_auth_params)
      user -> user
    end
  end

  defp authorize_url!("github"), do: GitHub.authorize_url!
  defp authorize_url!("google"), do: Google.authorize_url!
  defp authorize_url!(_), do: raise "No matching provider available"

  defp get_token!("github", code), do: GitHub.get_token!(code: code)
  defp get_token!("google", code), do: Google.get_token!(code: code)
  defp get_token!(_, _), do: raise "No matching provider available"

  defp get_user!("github", token), do: OAuth2.AccessToken.get!(token, "/user")
  defp get_user!("google", token) do
    %{access_token: access_token, other_params: %{"id_token" => id_token} } = token
    OAuth2.AccessToken.get!(token, "https://www.googleapis.com/oauth2/v3/tokeninfo?access_token=#{access_token}")
  end
end
