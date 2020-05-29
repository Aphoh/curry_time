defmodule CurryTimeWeb.GithubAuthController do
  use CurryTimeWeb, :controller
  require Logger

  alias CurryTime.Accounts
  alias CurryTime.Accounts.User
  alias CurryTimeWeb.UserAuth

  plug Ueberauth
  alias Ueberauth.Strategy.Helpers

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    %{email: email, name: name, image: image} = auth.info

    {:ok, user} =
      case Accounts.get_user_by_email(email) do
        %User{} = user ->
          Accounts.update_user_personal_information(user, %{name: name, image: image})

        nil ->
          Accounts.register_user(%{name: name, email: email, image: image}, random_password: true)
      end

    UserAuth.login_user(conn, user)
    |> put_flash(:info, "Successfully authenticated")
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
