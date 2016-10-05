#!/usr/bin/env elixir
Code.require_file("boiler_plate.exs")

defmodule FizzBuzz do
  def host, do: {192, 168, 16, 109}
  def port, do: 8080
  def filename, do: __ENV__.file
  def team, do: "teste"
  def password, do: "perdi"
  def challenge, do: "FizzBuzz"

  def solve(conn) do
    input = BoilerPlate.read_line(conn)
    [start, finish] = String.split(input)
    |> Enum.map(fn i -> elem(Integer.parse(i), 0) end)
    for i <- start..finish do
      BoilerPlate.write_line(conn, fizz_buzz(i))
    end
    BoilerPlate.write_line(conn, "EOF")
  end

  def fizz_buzz(n) when rem(n,15) == 0, do: "FizzBuzz"
  def fizz_buzz(n) when rem(n,5) == 0, do: "Buzz"
  def fizz_buzz(n) when rem(n,3) == 0, do: "Fizz"
  def fizz_buzz(n), do: n
end

BoilerPlate.connect(FizzBuzz)
