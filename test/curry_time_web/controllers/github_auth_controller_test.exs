defmodule CurryTimeWeb.GithubAuthControllerTest do
  use CurryTimeWeb.ConnCase, async: true

  alias CurryTime.AccountsFixtures

  describe "GET /auth/github" do
    test "redirects to github", %{conn: conn} do
      conn = get(conn, Routes.github_auth_path(conn, :request, "github"))
      assert redirected_to(conn) =~ "https://github.com/login/oauth/"
    end
  end

  describe "GET /auth/github/callback" do
    test "correctly logs in already registered user", %{conn: conn} do
      user = AccountsFixtures.user_fixture()

      auth = %Ueberauth.Auth{
        provider: :github,
        info: %{
          name: AccountsFixtures.valid_user_name(),
          image: AccountsFixtures.valid_user_image(),
          email: user.email
        }
      }

      conn =
        conn
        |> bypass_through(CurryTimeWeb.Router, [:browser])
        |> get("/auth/github/callback")
        |> assign(:ueberauth_auth, auth)
        |> CurryTimeWeb.GithubAuthController.callback(%{})

      assert get_flash(conn, :info) =~ "Successfully authenticated"
    end
  end
end
