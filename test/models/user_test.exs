defmodule Gts.UserTest do
  use Gts.ModelCase

  alias Gts.User

  require Gts.AES

  @valid_attrs %{avatar: "some content", email: "some content", github_id: "some content", name: "some content", encrypted_token: Gts.AES.encrypt('test')}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
