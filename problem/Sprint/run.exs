#!/usr/bin/env elixir

if List.first(System.argv) == "deploy" do
  "boiler_plate.exs"
else
  "local_plate.exs"
end
|> Code.require_file

defmodule Sprint do
  def host, do: 'localhost'
  def port, do: 8080
  def filename, do: __ENV__.file
  def team, do: "time"
  def password, do: "senha"
  def challenge, do: "Sprint"

  def solve(input) do
    [head | lines] = String.split(input, "\n", trim: true)
    [n, _m] = String.split(head)
    |> Enum.map(&String.to_integer/1)

    {names, jobs} = Enum.split(lines, n)

    devs = names
    |> Enum.with_index
    |> Enum.map(&build_dev/1)

    jobs = Enum.map(jobs, &String.to_integer/1)

    simulate(devs, jobs)
    |> Enum.sort_by(&(&1).index)
    |> Enum.map(&print_dev/1)
    |> IO.iodata_to_binary
  end

  def simulate(devs, []) do
    devs
  end

  def simulate(devs, [job | rest]) do
    dev = Enum.min_by(devs, fn d -> {d.free_at, d.index} end)
    dev = Map.merge(dev, %{free_at: dev.free_at + job, tasks: dev.tasks+1})
    devs = Enum.reject(devs, fn d -> d.name == dev.name end)
    devs = [dev | devs]
    simulate(devs, rest)
  end

  def build_dev({name, index}) do
    %{name: name, index: index, tasks: 0, free_at: 0}
  end

  def print_dev(dev) do
    "#{dev.name} #{dev.tasks}\n"
  end
end

BoilerPlate.connect(Sprint)
