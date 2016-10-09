#!/usr/bin/env elixir

if List.first(System.argv) == "deploy" do
  "boiler_plate.exs"
else
  "local_plate.exs"
end
|> Code.require_file

defmodule Perdido do
  def host, do: 'localhost'
  def port, do: 8080
  def filename, do: __ENV__.file
  def team, do: "time"
  def password, do: "senha"
  def challenge, do: "Perdido"

  def solve(input) do
    [_n | list] = String.split(input)
    |> Enum.map(&String.to_integer/1)

    list = Enum.sort(list)
    last = List.last(list)
    next_val = tl(list) ++ [last+2]
    {a, _b} = Enum.zip(list, next_val)
    |> Enum.find(fn {a, b} -> a+1 < b end)
    "#{a+1}\n"
  end
end

BoilerPlate.connect(Perdido)
