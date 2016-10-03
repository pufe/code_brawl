defmodule History.Contest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contests" do
    field :name, :string
    field :start, Ecto.DateTime
    field :finish, Ecto.DateTime
    has_many :selections, History.Selection
    many_to_many :challenges, History.Challenge, join_through: History.Selection
  end

  @required_fields ~w()
  @optional_fields ~w(name start finish selections challenges)

  def changeset(record, params \\ %{}) do
    cast(record, params, @required_fields ++ @optional_fields)
  end
end
