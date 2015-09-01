defmodule Officetournament.UserTest do
  use Officetournament.ModelCase

  alias Officetournament.User

  @valid_attrs %{email: "some content", name: "some content", username: "ausername"}
  @invalid_attrs %{email: "justan@email.com"}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
