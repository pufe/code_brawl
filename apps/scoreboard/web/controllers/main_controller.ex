defmodule MainController do
  use Scoreboard.Web, :controller

  def index(conn, _params) do
    with_contest(conn, fn conn, contest ->
      render_contest(conn, contest)
    end)
  end

  def show(conn, %{challenge: name}) do
    with_contest(conn, fn conn, contest ->
      case History.Contest.find_challenge(contest, name) do
        {:ok, challenge} ->
          render conn, "challenge.html", challenge: challenge
        true ->
          render_contest(conn, contest)
      end
    end)
  end

  defp render_contest(conn, contest) do
    render conn, "contest.html", scoreboard: Scoreboard.Calculator.process(contest)
  end

  defp with_contest(conn, action) do
    timestamp = DateTime.utc_now()
    case History.Contest.at_timestamp(timestamp) do
      {:ok, contest} ->
        action.(conn, contest)
      _ ->
        next_contest(conn, timestamp)
    end
  end

  defp next_contest(conn, timestamp) do
    case History.Contest.next_contest(timestamp) do
      {:ok, contest} ->
        render conn, "wait.html", contest: contest
      true ->
        render conn, "no_contest.html"
    end
  end
end
