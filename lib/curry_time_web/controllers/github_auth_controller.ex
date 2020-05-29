defmodule CurryTimeWeb.GithubAuthController do
  use CurryTimeWeb, :controller
  require Logger

  alias CurryTime.Accounts
  alias CurryTimeWeb.UserAuth

  plug Ueberauth
  alias Ueberauth.Strategy.Helpers

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    Logger.info("Got auth: #{inspect(auth)}")
    %{token: token} = auth.credentials
    %{email: email, name: name, image: image} = auth.info

    if user = Accounts.get_user_by_email(email) do
      {:ok, user} = Accounts.update_user_personal_information(user, %{name: name, email: email})

      UserAuth.login_user(conn, user)
      |> put_flash(:info, "Successfully authenticated")
    else
      conn
    end
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end
end
