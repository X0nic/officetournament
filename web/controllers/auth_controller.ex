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
    # Logger.debug user_params

    sign_in_via_auth conn, user_params
    #
    # conn
    # # |> put_session(:current_user_id, user.id)
    # |> put_session(:access_token, token.access_token)
    # |> redirect(to: "/")
  end

  defp sign_in_via_auth(conn, user_auth_params) do
    current_user = find_or_create_user(user_auth_params)

    conn
      |> put_session(:current_user_id, current_user.id)
      |> redirect(to: "/")
  end

  def find_or_create_user(user_auth_params) do
    %{"login" => user_name, "avatar_url" => url, "email" => email} = user_auth_params
    # try do
    #   ElixirStatus.Avatar.load! user_name, url
    # rescue
    #   e -> IO.inspect {"error", e}
    # end
    Logger.debug "user_name: #{user_name}"
    Logger.debug "url: #{url}"
    Logger.debug "email: #{email}"

    case Officetournament.UserSessionController.find_by_user_name(user_name) do
      nil -> Officetournament.UserSessionController.create_from_auth_params(user_auth_params)
      user -> user
    end
  end

  defp authorize_url!("github"), do: GitHub.authorize_url!
  #defp authorize_url!("google"), do: Google.authorize_url!
  defp authorize_url!(_), do: raise "No matching provider available"

  defp get_token!("github", code), do: GitHub.get_token!(code: code)
  #defp get_token!("google", code), do: Google.get_token!(code: code)
  defp get_token!(_, _), do: raise "No matching provider available"

  defp get_user!("github", token), do: OAuth2.AccessToken.get!(token, "/user")
  #defp get_user!("google", token), do: OAuth2.AccessToken.get!(token, "/user")
end
