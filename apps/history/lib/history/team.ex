defmodule History.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :password_hash, :string
    has_many :attempts, History.Attempt
  end

  @required_fields ~w()
  @optional_fields ~w(name password_hash)

  def changeset(record, params \\ %{}) do
    cast(record, params, @required_fields ++ @optional_fields)
  end
end
