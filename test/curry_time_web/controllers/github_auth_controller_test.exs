defmodule CurryTimeWeb.GithubAuthControllerTest do
  use CurryTimeWeb.ConnCase, async: true
  require IO

  alias CurryTime.{AccountsFixtures, Accounts}

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
        |> with_auth(auth)
        |> CurryTimeWeb.GithubAuthController.callback(%{})

      assert get_flash(conn, :info) =~ "Successfully authenticated"
    end

    test "correctly updates information of existing users", %{conn: conn} do
      %{email: email, id: id} = AccountsFixtures.user_fixture(%{name: nil, image: nil})

      auth = %Ueberauth.Auth{
        provider: :github,
        info: %{
          name: "new name",
          image: "new image",
          email: email
        }
      }

      conn
      |> with_auth(auth)
      |> CurryTimeWeb.GithubAuthController.callback(%{})

      new_user = Accounts.get_user!(id)
      assert new_user.name == "new name"
      assert new_user.image == "new image"
    end

    test "correctly makes a new user account if none exists", %{conn: conn} do
      email = AccountsFixtures.unique_user_email()
      name = AccountsFixtures.valid_user_name()
      image = AccountsFixtures.valid_user_image()

      assert nil == Accounts.get_user_by_email(email)

      auth = %Ueberauth.Auth{
        provider: :github,
        info: %{
          name: name,
          image: image,
          email: email
        }
      }

      conn
      |> with_auth(auth)
      |> CurryTimeWeb.GithubAuthController.callback(%{})

      assert user = Accounts.get_user_by_email(email)
      assert user.name == name
      assert user.image == image
    end
  end

  defp with_auth(conn, %Ueberauth.Auth{} = auth),
    do:
      conn
      |> bypass_through(CurryTimeWeb.Router, [:browser])
      |> get("/auth/github/callback")
      |> assign(:ueberauth_auth, auth)
end
