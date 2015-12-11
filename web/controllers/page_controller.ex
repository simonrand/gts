defmodule Gts.PageController do
  use Gts.Web, :controller

  def index(conn, _params) do
    case user = get_session(conn, :current_user) do
      user ->
        github_response = GitHub.get_repos

        IO.puts github_response.headers["Link"]

        # Sigh.. regex?

        #"<https://api.github.com/user/repos?page=2>; rel=\"next\", <https://api.github.com/user/repos?page=" <> total_pages = github_response.headers["Link"]

        # links = String.split(github_response.headers["Link"], ", ")

        #[_, url, rel] = Regex.run(~r/<(.+)>; *rel="(.+)"/, List.first(links))
    end

    render conn, "index.html", current_user: user, repos: github_response.body, total_pages: total_pages
  end
end
