defmodule Gts.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :encrypted_token, :binary
      add :avatar, :string
      add :github_id, :string

      timestamps
    end

  end
end
