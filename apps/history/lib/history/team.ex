defmodule History.Team do
  use Ecto.Schema
  import Ecto.Changeset
  require Ecto.Query

  schema "teams" do
    field :name, :string
    field :password, :string
    has_many :attempts, History.Attempt
  end

  @required_fields ~w()
  @optional_fields ~w(name password)

  def changeset(record, params \\ %{}) do
    cast(record, params, @required_fields ++ @optional_fields)
  end

  def authenticate(team_name, team_password) do
    case (Ecto.Query.from(t in History.Team,
                           where: (t.name == ^team_name and
                                   t.password == ^team_password),
                           limit: 1)
          |> History.Repo.one) do
      nil -> :not_found
      team -> {:ok, team}
    end
  end
end
