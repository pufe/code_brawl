defmodule Arena.Bouncer do
  def listen(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary,
                                           active: false,
                                           reuseaddr: true,
                                           packet: :line])
    accept(socket)
    listen(port)
  end

  def accept(socket) do
    {:ok, conn} = :gen_tcp.accept(socket)
    with(submission_time <- DateTime.utc_now(),
         {:ok, contest} <- History.Contest.at_timestamp(submission_time)) do
      Arena.Queue.push(conn, contest)
    else
      _ -> :gen_tcp.send(conn, "No contest running.")
    end
    :gen_tcp.close(conn)
    accept(socket)
  end
end
