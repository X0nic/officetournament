defmodule Officetournament.GameTest do
  use Officetournament.ModelCase

  alias Officetournament.Game

  @valid_attrs %{away_id: 42, home_id: 42, league_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Game.changeset(%Game{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Game.changeset(%Game{}, @invalid_attrs)
    refute changeset.valid?
  end
end
