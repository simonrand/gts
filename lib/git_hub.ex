defmodule GitHub do
  use HTTPoison.Base

  def process_url(url) do
    "https://api.github.com" <> url
  end

  def process_request_headers(headers) do
    [{"Authorization", "token #{Application.get_env :httpoison, :github_token}"} | headers]
  end

  def get_repos do
    Stream.resource(
      fn -> fetch_page(1) end,
      &process_page/1,
      fn _ -> end
    )
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end

  defp fetch_page(page) do
    %{body: repos, headers: headers} = get!("/user/repos?page=#{page}") # TODO: Handle errors
    {repos, get_next_page(headers)}
  end

  defp process_page({nil, nil}) do
    {:halt, nil}
  end

  defp process_page({nil, next_page}) do
    next_page
    |> fetch_page
    |> process_page
  end

  defp process_page({repos, next_page}) do
    {repos, {nil, next_page}}
  end

  defp extract_and_parse_link_header(headers) do
    case Enum.into(headers, %{}) do
      %{"Link" => link} -> ExLinkHeader.parse!(link)
      _ -> nil
    end
  end

  defp get_next_page(headers) do
    case extract_and_parse_link_header(headers) do
      %{"next" => %{page: page}} -> page
      _ -> nil
    end
  end
end
