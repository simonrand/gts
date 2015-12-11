defmodule Gts.AuthController do
  use Gts.Web, :controller

  plug Ueberauth

  import GitHub

  alias Gts.User
  alias Ueberauth.Strategy.Helpers

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{ assigns: %{ ueberauth_failure: fails } } = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{ assigns: %{ ueberauth_auth: auth } } = conn, params) do
    conn
    |> handle_callback(get_user_from_github_id(auth.uid), auth)
    |> redirect(to: "/")
  end

  defp handle_callback(conn, nil, auth) do
    user = User.changeset(%User{}, %{
      name: auth.info.name,
      github_id: auth.uid,
      avatar: auth.info.urls.avatar_url,
      encrypted_token: auth.credentials.token
    })

    if user.valid? do
      conn
      |> put_user_in_session(Repo.insert!(user))
    else
      conn
      |> put_flash(:error, "Could not sign in using GitHub.")
    end
  end

  defp handle_callback(conn, user, auth) do
    user_changeset = User.changeset(user, %{
      encrypted_token: auth.credentials.token
    })

    if user_changeset.valid? do
      conn
      |> put_user_in_session(Repo.update!(user_changeset))
    else
      conn
      |> put_flash(:error, "Signed in, but could not update GitHub Access token.")
    end
  end

  defp put_user_in_session(conn, user) do
    Application.put_env :httpoison, :github_token, user.encrypted_token

    conn
    |> put_session(:current_user, user)
    |> put_flash(:info, "Successfully authenticated.")
  end

  defp get_user_from_github_id(github_id) do
    Repo.one(from u in User, where: u.github_id == ^github_id)
  end

  defp create_user_from_auth(auth) do

  end
end
