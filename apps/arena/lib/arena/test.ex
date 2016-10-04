defmodule Arena.Test do
  def run(_conn, _challenge, 0) do
    "Accepted"
  end

  def run(conn, challenge, test_number) do
    send_input(conn, challenge, test_number)
    answer = receive_output(conn, challenge.time_limit)
    case compare_solution(answer, challenge) do
      :ok -> run_tests(conn, challenge, test_number - 1)
      :wa -> "Wrong answer"
      :tl -> "Time limit exceeded"
      :dc -> "Disconnected mid run"
      _ -> "Unknown error"
    end
  end

  def send_input(conn, challenge, test_number) do
    file = File.open(Path.join(["./problem", challenge.name, "input#{test_number}"]), [:read])
    write_file(conn, file)
  end

  def write_file(conn, file) do
    case IO.gets(file, nil) do
      :eof -> :eof
      line -> :gen_tcp.send(conn, line)
        send_file(conn, file)
    end
  end

  def receive_output(conn, time_limit) do
    case :gen_tcp.recv(conn, 0, time_limit) do
      {:ok, first_line} -> read_output(conn, [first_line])
      {:error, :timeout} -> :tl
      {:error, _} -> :dc
      _ -> :unknown
    end
  end

  def read_output(conn, partial_output) do
    case :gen_tcp.recv(conn, 0, 50) do
      {:ok, "EOF\n"} -> IO.iodata_to_binary(Enum.reverse(partial_output))
      {:ok, line} -> read_output(conn, [line | partial_output])
      {:error, _} -> :dc
      _ -> :unknown
    end
  end

  def compare_solution(answer when is_atom(answer), _challenge), do: answer

  def compare_solution(answer, challenge) do
    solution = File.read(Path.join(["./problem", challenge.name, "solution#{test_number}"]), [:read])
    if answer == solution do
      :ok
    else
      :wa
    end
  end
end
