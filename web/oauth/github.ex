defmodule GitHub do
  @moduledoc """
  An OAuth2 strategy for GitHub.
  """
  use OAuth2.Strategy

  alias OAuth2.Strategy.AuthCode

  # Public API

  def client(oauth_client_params) do
    OAuth2.Client.new([
      strategy: __MODULE__,
      client_id: System.get_env("GITHUB_CLIENT_ID"),
      client_secret: System.get_env("GITHUB_CLIENT_SECRET"),
      redirect_uri: oauth_client_params.redirect_uri,
      site: "https://api.github.com",
      authorize_url: "https://github.com/login/oauth/authorize",
      token_url: "https://github.com/login/oauth/access_token"
    ])
  end

  def authorize_url!(oauth_client_params \\ %{}, params \\ []) do
    OAuth2.Client.authorize_url!(client(oauth_client_params), params)
  end

  def get_token!(oauth_client_params \\ %{}, params \\ [], headers \\ []) do
    OAuth2.Client.get_token!(client(oauth_client_params), params)
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
