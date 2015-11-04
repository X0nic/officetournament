defmodule Officetournament.Repo.Migrations.CreateMembership do
  use Ecto.Migration

  def change do
    create table(:memberships) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :league_id, references(:leagues, on_delete: :delete_all)

      timestamps
    end

    create unique_index(:memberships, [:user_id, :league_id])

  end
end
