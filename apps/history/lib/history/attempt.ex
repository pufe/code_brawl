defmodule History.Attempt do
  use Ecto.Schema
  import Ecto.Changeset

  schema "attempts" do
    field :time, Ecto.DateTime
    field :status, :string
    field :source, :string
    belongs_to :challenge, History.Challenge
    belongs_to :team, History.Team
  end

  @required_fields ~w()
  @optional_fields ~w(time status source challenge team)

  def changeset(record, params \\ %{}) do
    cast(record, params, @required_fields ++ @optional_fields)
  end
end
