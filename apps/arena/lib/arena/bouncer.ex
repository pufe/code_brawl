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
    Arena.Queue.push(conn)
    accept(socket)
  end
end
