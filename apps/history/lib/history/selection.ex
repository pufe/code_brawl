defmodule History.Selection do
  use Ecto.Schema
  import Ecto.Changeset

  schema "selections" do
    belongs_to :contest, History.Contest
    belongs_to :challenge, History.Challenge
  end

  @required_fields ~w()
  @optional_fields ~w(contest challenge)

  def changeset(record, params \\ :empty) do
    cast(record, params, @required_fields ++ @optional_fields)
  end
end
