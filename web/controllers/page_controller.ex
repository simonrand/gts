defmodule Gts.PageController do
  use Gts.Web, :controller

  def index(conn, _params) do
    user =
      case get_session(conn, :current_user) do
        user ->
          repos = GitHub.get_repos
          user
        nil ->
          conn
          |> configure_session(drop: true)
      end

    render conn, "index.html", current_user: user, repos: repos
  end
end
