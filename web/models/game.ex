defmodule Officetournament.Game do
  use Officetournament.Web, :model

  schema "games" do
    field :league_id, :integer
    field :home_id, :integer
    field :away_id, :integer

    timestamps
  end

  @required_fields ~w(league_id home_id away_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
