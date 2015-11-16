defmodule Officetournament.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :league_id, :integer
      add :home_id, :integer
      add :away_id, :integer

      timestamps
    end

  end
end
