defmodule Scoreboard.BalloonFeed do
  def fetch(contest) do
    require Ecto.Query
    Ecto.Query.from(a in History.Attempt,
                    join: c in assoc(a, :challenge),
                    join: t in assoc(a, :team),
                    where: (a.status == "Accepted" and
                            c.contest_id == ^contest.id),
                    preload: [:team, :challenge],
                    order_by: [desc: a.time])
    |> History.Repo.all
  end
end
