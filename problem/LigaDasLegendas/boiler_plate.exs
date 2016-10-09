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
      "Test:" ->
        read_input(conn, [])
        |> solver.solve()
        |> (&:gen_tcp.send(conn, &1)).()
        write_line(conn, "EOF")
      "Source:" -> write_source(conn, solver.filename)
      result -> IO.puts(result)
    end
  end

  def read_input(conn, partial_input) do
    case :gen_tcp.recv(conn, 0) do
      {:ok, "EOF\n"} ->
        compile(partial_input)
      {:ok, line} ->
        read_input(conn, [line | partial_input])
      _ ->
        compile(partial_input)
    end
  end

  def compile(list_of_strings) do
    list_of_strings
    |> Enum.reverse
    |> IO.iodata_to_binary
  end

  def write_line(conn, line) do
    :gen_tcp.send(conn, "#{line}\n")
  end

  def write_source(conn, filename) do
    :gen_tcp.send(conn, File.read!(filename))
  end
end
