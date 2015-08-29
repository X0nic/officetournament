defmodule Officetournament.User do
  use Officetournament.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :username, :string
    field :password, :string

    timestamps
  end

  @required_fields ~w(name email username)
  @optional_fields ~w(password)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
