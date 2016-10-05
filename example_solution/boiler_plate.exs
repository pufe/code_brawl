defmodule BoilerPlate do
  def connect(solver) do
    case :gen_tcp.connect(solver.host,
                          solver.port,
                          [:binary,
                           active: false,
                           packet: :line]) do
      {:ok, conn} -> loop(conn, solver)
      _ -> IO.puts("Unable to connect.")
    end
  end

  def loop(conn, solver) do
    case :gen_tcp.recv(conn, 0) do
      {:ok, message} ->
        action(conn, solver, String.trim_trailing(message))
        loop(conn, solver)
      _ ->
        :end
    end
  end

  def action(conn, solver, command) do
    case command do
      "Team:" -> write_line(conn, solver.team)
      "Password:" -> write_line(conn, solver.password)
      "Challenge:" -> write_line(conn, solver.challenge)
      "Test:" -> solver.solve(conn)
      "Source:" -> write_source(conn)
      result -> IO.puts(result)
    end
  end

  def write_line(conn, line) do
    :gen_tcp.send(conn, "#{line}\n")
  end

  def write_source(conn) do
    :gen_tcp.send(conn, File.read!(solver.filename))
  end

  def read_line(conn) do
    case :gen_tcp.recv(conn, 0) do
      {:ok, line} -> String.trim_trailing(line)
      _ -> :error
    end
  end
end
