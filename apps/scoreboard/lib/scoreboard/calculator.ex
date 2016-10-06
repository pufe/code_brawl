defmodule Scoreboard.Calculator do
  def process(contest) do
    teams = History.Repo.all(History.Team)
    challenges = History.Repo.preload(contest, :challenges).challenges
    teams = Enum.map(teams, &(process_team(new_team_data(&1), challenges, contest)))
    |> Enum.sort_by(fn data -> {-data.score, data.penalty, data.team.name} end)
    %{contest: contest, challenges: challenges, teams: teams}
  end

  def process_team(team, [], contest) do
    %{team: team, score: score, penalty: penalty, challenges: Enum.reverse(challenges)}
  end

  def process_team(team, [challenge|rest], contest) do
    [solved, attempts, time] = score_challenge(team, challenge, contest)
    team = if solved do
      Map.merge(team, %{score: team.score + 1, penalty: team.penalty + time + attempts*20})
    else
      team
    end
    team = Map.merge(team, %{challenges: [[solved, attempts, time] | team.challenges]})
    process_team(team, rest, contest)
  end

  def score_challenge(team, challenge, contest) do
    case History.Team.first_accepted(team, challenge) do
      {:ok, attempt} ->
        solved = true
        attempts = History.Team.count_attempts_before(team, challenge, attempt)
        time = attempt.time - contest.start
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
end
