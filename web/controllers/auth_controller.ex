defmodule Officetournament.AuthController do
  use Officetournament.Web, :controller
  require Logger

  @doc """
  This action is reached via `/auth/:provider` and redirects to the OAuth2 provider
  based on the chosen strategy.
  """
  def index(conn, %{"provider" => provider}) do
    redirect conn, external: authorize_url!(provider, %{ redirect_uri: auth_url(conn, :callback, provider) })
  end

  @doc """
  This action is reached via `/auth/:provider/callback` is the the callback URL that
  the OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"provider" => provider, "code" => code}) do
    # Exchange an auth code for an access token
    token = get_token!(provider, %{ redirect_uri: auth_url(conn, :callback, provider) }, code)

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

  defp authorize_url!("github", oauth_client_params), do: GitHub.authorize_url!(oauth_client_params)
  defp authorize_url!("google", oauth_client_params), do: Google.authorize_url!(oauth_client_params)
  defp authorize_url!(_, _), do: raise "No matching provider available"

  defp get_token!("github", oauth_client_params, code), do: GitHub.get_token!(oauth_client_params, code: code)
  defp get_token!("google", oauth_client_params, code), do: Google.get_token!(oauth_client_params, code: code)
  defp get_token!(_, _, _), do: raise "No matching provider available"

  defp get_user!("github", token), do: GitHub.get_user!(token)
  defp get_user!("google", token), do: Google.get_user!(token)
end
