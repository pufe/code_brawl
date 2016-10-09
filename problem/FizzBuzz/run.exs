#!/usr/bin/env elixir

if List.first(System.argv) == "deploy" do
  "boiler_plate.exs"
else
  "local_plate.exs"
end
|> Code.require_file

defmodule FizzBuzz do
  def host, do: 'localhost'
  def port, do: 8080
  def filename, do: __ENV__.file
  def team, do: "time"
  def password, do: "senha"
  def challenge, do: "FizzBuzz"

  def solve(input) do
    [start, finish] = String.split(input)
    |> Enum.map(&String.to_integer/1)

    start..finish
    |> Enum.map(&fizz_buzz/1)
    |> Enum.join("")
  end

  def fizz_buzz(n) when rem(n,15) == 0, do: "FizzBuzz\n"
  def fizz_buzz(n) when rem(n,5) == 0, do: "Buzz\n"
  def fizz_buzz(n) when rem(n,3) == 0, do: "Fizz\n"
  def fizz_buzz(n), do: "#{n}\n"
end

BoilerPlate.connect(FizzBuzz)
