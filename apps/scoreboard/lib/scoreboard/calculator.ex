defmodule Scoreboard.Calculator do
  def process(contest) do
    teams = History.Repo.all(History.Team)
    challenges = History.Repo.preload(contest, :challenges).challenges
    teams = Enum.map(teams, &(process_team(new_team_data(&1), challenges, contest)))
    |> Enum.sort_by(fn data -> {-data.score, data.penalty, data.team.name} end)
    %{contest: contest, challenges: challenges, teams: teams}
  end

  def process_team(team, [], _contest) do
    Map.merge(team, %{challenges: Enum.reverse(team.challenges)})
  end

  def process_team(team, [challenge|rest], contest) do
    [solved, attempts, time] = score_challenge(team.team, challenge, contest)
    team = if solved do
      Map.merge(team, %{score: team.score + 1, penalty: team.penalty + time + attempts*5})
    else
      team
    end
    team = Map.merge(team, %{challenges: [[solved, attempts, time, challenge.color] | team.challenges]})
    process_team(team, rest, contest)
  end

  def score_challenge(team, challenge, contest) do
    case History.Team.first_accepted(team, challenge) do
      {:ok, accepted} ->
        solved = true
        attempts = History.Team.count_attempts_before(team, challenge, accepted.time)
        time = compute_minutes(accepted.time, contest.start)
        [solved, attempts, time]
      _ ->
        solved = false
        attempts = History.Team.count_attempts(team, challenge)
        time = nil
        [solved, attempts, time]
    end
  end

  def new_team_data(team) do
    %{team: team, score: 0, penalty: 0, challenges: []}
  end

  def to_seconds(datetime) do
    datetime
    |> Ecto.DateTime.to_erl
    |> :calendar.datetime_to_gregorian_seconds
  end

  def compute_minutes(datetime1, datetime2) do
    div(to_seconds(datetime1) - to_seconds(datetime2), 60)
  end
end
