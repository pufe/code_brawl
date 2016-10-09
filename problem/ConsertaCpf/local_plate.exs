defmodule BoilerPlate do
  def connect(solver) do
    read_input([])
    |> solver.solve()
    |> IO.write
  end


  def read_input(partial_input) do
    case IO.gets("") do
      "EOF\n" -> compile(partial_input)
      :eof -> compile(partial_input)
      {:error, _ } -> compile(partial_input)
      line -> read_input([line | partial_input])
    end
  end

  def compile(list_of_strings) do
    list_of_strings
    |> Enum.reverse
    |> IO.iodata_to_binary
  end
end
