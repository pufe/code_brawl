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
  def challenge, do: "ConsertaCpf"

  def solve(input) do
    Regex.replace(~r/[^0-9]/, input, "")
    |> String.pad_leading(11, "0")
    |> String.slice(0, 11)
    |> (fn x ->
      Regex.replace(~r/(...)(...)(...)(..)/, x, "\\1.\\2.\\3-\\4\n")
    end).()
  end
end

BoilerPlate.connect(Run)
