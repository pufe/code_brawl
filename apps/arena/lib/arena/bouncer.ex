defmodule Arena.Bouncer do
  def listen(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary,
                                           active: false,
                                           reuseaddr: true,
                                           exit_on_close: true])
    accept(socket)
  end

  def accept(socket) do
    {:ok, conn} = :gen_tcp.accept(socket)
    submission_time = DateTime.utc_now()
    contest = History.Contest.at_timestamp(submission_time)
    if contest do
      Arena.Queue.push(conn, contest)
    else
      :gen_tcp.close(conn)
    end
    accept(socket)
  end
end
