defmodule History.Contest do
  use Ecto.Schema
  import Ecto.Changeset
  require Ecto.Query

  schema "contests" do
    field :name, :string
    field :start, Ecto.DateTime
    field :finish, Ecto.DateTime
    has_many :challenges, History.Challenge
  end

  @required_fields ~w()
  @optional_fields ~w(name start finish)

  def changeset(record, params \\ %{}) do
    cast(record, params, @required_fields ++ @optional_fields)
  end

  def at_timestamp(timestamp) do
    case(Ecto.Query.from(c in History.Contest,
                         where: (c.start <= ^timestamp and
                                 c.finish > ^timestamp),
                         limit: 1)
         |> History.Repo.one) do
      nil -> :error
      contest -> {:ok, History.Repo.preload(contest, :challenges)}
    end
  end

  def find_challenge(contest, challenge_name) do
    case(History.Repo.preload(contest, :challenges).challenges
         |> Enum.filter(&(&1.name == challenge_name))
         |> List.first) do
      nil -> :error
      challenge -> {:ok, challenge}
    end
  end

  def next_contest(timestamp) do
    case(Ecto.Query.from(c in History.Contest,
                         where: c.start > ^timestamp,
                         order_by: [asc: c.start],
                         limit: 1)
         |> History.Repo.one) do
      nil -> nil
      contest -> {:ok, contest}
    end
  end
end
