#!/usr/bin/env elixir

if List.first(System.argv) == "deploy" do
  "boiler_plate.exs"
else
  "local_plate.exs"
end
|> Code.require_file

defmodule Run do
  def host, do: 'localhost'
  def port, do: 8080
  def filename, do: __ENV__.file
  def team, do: "time"
  def password, do: "senha"
  def challenge, do: "Parcerias"

  def solve(input) do
    [n | lines] = String.split(input, "\n", trim: true)
    n = String.to_integer(n)
    lines = Enum.map(lines, fn l ->
      (String.split(l) |> Enum.map(&String.to_integer/1))
    end)
    |> Enum.with_index(1)

    graph = generate_graph(lines, %{})

    result = permutations(Enum.into(2..n, []))
    |> Enum.min_by(fn x -> {calculate_cost(x, graph), x} end)
    |> Enum.map(&to_string/1)
    |> Enum.join(" ")
    "1 #{result} 1\n"
  end

  def permutations([]) do
    [[]]
  end

  def permutations(list) do
    Enum.flat_map(list, fn el ->
      permutations(list -- [el])
      |> Enum.map(fn partial ->
        [el | partial]
      end)
    end)
  end

  def generate_graph([], map) do
    map
  end

  def generate_graph([{line, idx} | rest], map) do
    generate_graph(rest, add_line(Enum.with_index(line, 1), idx, map))
  end

  def add_line([], _idx, map) do
    map
  end

  def add_line([{distance, idx_j} |rest], idx_i, map) do
    add_line(rest, idx_i, Map.put(map, {idx_i, idx_j}, distance))
  end

  def calculate_cost(x, graph) do
    Enum.zip([1 | x], x ++ [1])
    |> Enum.reduce(0, fn {a, b}, acc -> acc + Map.get(graph, {a, b}) end)
  end
end

BoilerPlate.connect(Run)
