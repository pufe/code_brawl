defmodule History.Challenge do
  use Ecto.Schema
  import Ecto.Changeset

  schema "challenges" do
    field :name, :string
    field :description, :string
    field :time_limit, :integer
    field :test_count, :integer
    has_many :attempts, History.Attempt
    belongs_to :contest, History.Contest
  end

  @required_fields ~w()
  @optional_fields ~w(name description time_limit test_count)

  def changeset(record, params \\ %{}) do
    cast(record, params, @required_fields ++ @optional_fields)
    |> cast_assoc(:contest)
  end
end
