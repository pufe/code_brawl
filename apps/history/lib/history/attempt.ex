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
  @optional_fields ~w(time status source challenge_id team_id)

  def changeset(record, params \\ %{}) do
    cast(record, params, @required_fields ++ @optional_fields)
  end

  def create(params = %{team: %History.Team{},
                        challenge: %History.Challenge{},
                        status: _status,
                        time: _time}) do
    params
    |> Map.merge(%{team_id: params.team.id, challenge_id: params.challenge.id})
    |> (&changeset(%History.Attempt{}, &1)).()
    |> History.Repo.insert!
  end

  def update(attempt, params = %{source: _source, status: _status}) do
    History.Repo.update!(changeset(attempt, params))
  end
end
