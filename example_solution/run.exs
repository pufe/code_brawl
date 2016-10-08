#!/usr/bin/env elixir

if List.first(System.argv) == "deploy" do
  "boiler_plate.exs"
else
  "local_plate.exs"
end
|> Code.require_file

defmodule Run do
  def host, do: {192, 168, 16, 107}
  def port, do: 8080
  def filename, do: __ENV__.file
  def team, do: "seu time"
  def password, do: "sua senha"
  def challenge, do: "nome do problema"

  def solve(input) do
    "saída\n"
  end
end

BoilerPlate.connect(Run)
