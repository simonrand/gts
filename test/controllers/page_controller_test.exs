defmodule Gts.PageControllerTest do
  use Gts.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "Please Login"
  end
end
