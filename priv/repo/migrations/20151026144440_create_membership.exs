defmodule Officetournament.Repo.Migrations.CreateMembership do
  use Ecto.Migration

  def change do
    create table(:memberships) do
      add :user_id, references(:users)
      add :league_id, references(:leagues)

      timestamps
    end

    create unique_index(:memberships, [:user_id, :league_id])

  end
end
