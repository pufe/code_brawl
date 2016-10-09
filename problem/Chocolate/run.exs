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
  def challenge, do: "Chocolate"

  def solve(input) do
    [first_line | rest] = String.split(input, "\n", trim: true)
    [n, d, v] = String.split(first_line)
    |> Enum.map(&String.to_integer/1)
    products = Enum.map(rest, &parse_product/1)
    { result, _memo } = max_chocolate(products, {n, d, v}, %{})
    "#{result}\n"
  end

  def parse_product(line) do
    String.split(line)
    |> Enum.map(&String.to_integer/1)
  end

  def max_chocolate([], _state, memo) do
    { 0, memo }
  end

  def max_chocolate([[volume, price, chocolate] | rest], {n, d, v}, memo) do
    answer = Map.get(memo, {n, d, v})
    if answer do
      { answer, memo }
    else
      { dont_take, memo } = max_chocolate(rest, {n-1, d, v}, memo)
      take = 0
      { take, memo } = if price <= d && volume <= v do
        { take, memo } = max_chocolate(rest, {n-1, d-price, v-volume}, memo)
        { take + chocolate, memo }
      else
        { 0, memo }
      end
      answer = max(dont_take, take)
      memo = Map.put(memo, {n, d, v}, answer)
      { answer, memo }
    end
  end

end

BoilerPlate.connect(Run)
