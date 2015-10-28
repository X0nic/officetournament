defmodule Officetournament.Membership do
  use Officetournament.Web, :model

  schema "memberships" do
    field :user_id, :integer
    field :league_id, :integer

    timestamps
  end

  @required_fields ~w(user_id league_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:league_id)
    # |> unique_constraint(:user_id, name: :memberships_user_id_league_id_index)
    # |> unique_constraint(:league_id, name: :memberships_user_id_league_id_index)
  end
end
