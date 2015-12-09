defmodule Gts.User do
  use Gts.Web, :model

  alias Ueberauth.Auth
  alias Ueberauth.Auth.Credentials

  schema "users" do
    field :name, :string
    field :email, :string
    field :encrypted_token, Gts.EncryptedField
    field :avatar, :string
    field :github_id, :string

    timestamps
  end

  @required_fields ~w(name encrypted_token avatar github_id)
  @optional_fields ~w(email)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
