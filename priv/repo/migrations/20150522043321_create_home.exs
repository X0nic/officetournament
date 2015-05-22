defmodule Officetournament.Repo.Migrations.CreateHome do
  use Ecto.Migration

  def change do
    create table(:homes) do

      timestamps
    end
  end
end
