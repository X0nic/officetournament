defmodule Officetournament.HomeTest do
  use Officetournament.ModelCase

  alias Officetournament.Home

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Home.changeset(%Home{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Home.changeset(%Home{}, @invalid_attrs)
    refute changeset.valid?
  end
end
