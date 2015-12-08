defmodule Gts.User do
  use Gts.Web, :model

  import Ecto.Query

  alias Gts.Repo
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

  # Move to auth controller
  def find_or_create(%Auth{} = auth) do
    case find_user_by_github_id(auth.uid) do
      nil ->
        user_changeset = changeset(%Gts.User{}, %{
          name: auth.info.name,
          github_id: auth.uid,
          avatar: auth.info.urls.avatar_url,
          encrypted_token: auth.credentials.token
        })

        if user_changeset.valid? do
          {:ok, Repo.insert!(user_changeset)}
        else
          {:error, 'Could not sign in using GitHub.'}
        end
      user -> {:ok, user}
    end
  end

  def find_user_by_github_id(github_id) do
    query = from u in Gts.User,
          where: u.github_id == ^github_id,
         select: u
    Repo.one(query)
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name = [auth.info.first_name, auth.info.last_name]
      |> Enum.filter(&(&1 != nil and &1 != ""))
      if length(name) == 0, do: auth.info.nickname, else: name = Enum.join(name, " ")
    end
  end
end
