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
  def challenge, do: "Campeonato"

  def solve(input) do
    [n, m] = String.split(input)
    |> Enum.map(&String.to_integer/1)
    total = div(n*(n-1)*(n-2), 2)
    weeks = div(total + m - 1, m)
    "#{weeks}\n"
  end
end

BoilerPlate.connect(Run)
