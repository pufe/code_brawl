defmodule Scoreboard.MainController do
  use Scoreboard.Web, :controller

  def current_contest(conn, _params) do
    with_contest(conn, fn conn, contest ->
      render_contest(conn, contest, true)
    end)
  end

  def balloon_feed(conn, _params) do
    with_contest(conn, fn conn, contest ->
      render conn, "balloon_feed.html", ac_list: Scoreboard.BalloonFeed.fetch(contest)
    end)
  end

  def show_challenge(conn, %{"challenge" => name}) do
    with_contest(conn, fn conn, contest ->
      case History.Contest.find_challenge(contest, name) do
        {:ok, challenge} ->
          render conn, "challenge.html", challenge: challenge
        true ->
          render_contest(conn, contest, true)
      end
    end)
  end

  def show_contest(conn, %{"id" => id}) do
    case History.Repo.get(History.Contest, id) do
      nil -> current_contest(conn, nil)
      contest -> render_contest(conn, contest, false)
    end
  end

  defp render_contest(conn, contest, reload) do
    render conn, "contest.html", scoreboard: Scoreboard.Calculator.process(contest), reload: reload
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
      _ ->
        render conn, "no_contest.html"
    end
  end
end
