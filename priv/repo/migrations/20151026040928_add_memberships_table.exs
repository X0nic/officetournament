defmodule Officetournament.Repo.Migrations.AddMembershipsTable do
  use Ecto.Migration

  def change do
    create table(:memberships) do
      add :user_id,   :integer
      add :league_id, :integer

      timestamps
    end
  end
end
