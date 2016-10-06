defmodule History.Team do
  use Ecto.Schema
  import Ecto.Changeset
  require Ecto.Query

  schema "teams" do
    field :name, :string
    field :password, :string
    field :hidden, :boolean
    has_many :attempts, History.Attempt
  end

  @required_fields ~w()
  @optional_fields ~w(name password hidden)

  def changeset(record, params \\ %{}) do
    cast(record, params, @required_fields ++ @optional_fields)
  end

  def authenticate(team_name, team_password) do
    case(Ecto.Query.from(t in History.Team,
                         where: (t.name == ^team_name and
                                 t.password == ^team_password),
                         limit: 1)
         |> History.Repo.one) do
      nil -> :not_found
      team -> {:ok, team}
    end
  end

  def first_accepted(team, challenge) do
    case(Ecto.Query.from(a in History.Attempt,
                         where: (a.team_id == ^team.id and
                                 a.challenge_id == ^challenge.id and
                                 a.status == "Accepted"),
                         order_by: [asc: a.time],
                         limit: 1)
         |> History.Repo.one) do
      nil -> nil
      attempt -> {:ok, attempt}
    end
  end

  def count_attempts_before(team, challenge, timestamp) do
    Ecto.Query.from(a in count_attempt_query(team, challenge),
                    where: (a.time <= ^timestamp))
    |> History.Repo.one
  end

  def count_attempts(team, challenge) do
    History.Repo.one(count_attempt_query(team, challenge))
  end

  defp count_attempt_query(team, challenge) do
    Ecto.Query.from(a in History.Attempt,
                    where: (a.team_id == ^team.id and
                            a.challenge_id == ^challenge.id),
                    select: count(a.id))
  end
end
