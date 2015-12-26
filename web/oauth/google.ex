defmodule Google do
  @moduledoc """
  An OAuth2 strategy for Google.
  """
  use OAuth2.Strategy

  alias OAuth2.Strategy.AuthCode

  # Public API

  def client(oauth_client_params) do
    OAuth2.Client.new([
      strategy: __MODULE__,
      client_id: System.get_env("GOOGLE_CLIENT_ID"),
      client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
      redirect_uri: oauth_client_params.redirect_uri,
      site: "https://accounts.google.com",
      authorize_url: "/o/oauth2/auth",
      token_url: "/o/oauth2/token",
    ])
  end

  def authorize_url!(oauth_client_params \\ %{}, params \\ []) do
    oauth_client_params
    |> client
    |> put_param(:scope, "email profile openid")
    |> OAuth2.Client.authorize_url!(params)
  end

  def get_token!(oauth_client_params \\ %{}, params \\ [], headers \\ []) do
    oauth_client_params
    |> client
    |> OAuth2.Client.get_token!(params)
  end

  def get_user!(token) do
   OAuth2.AccessToken.get!(token, "https://www.googleapis.com/plus/v1/people/me/openIdConnect")
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end
end
