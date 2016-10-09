#!/usr/bin/env elixir

if List.first(System.argv) == "deploy" do
  "boiler_plate.exs"
else
  "local_plate.exs"
end
|> Code.require_file

defmodule LigaDasLegendas do
  def host, do: 'localhost'
  def port, do: 8080
  def filename, do: __ENV__.file
  def team, do: "time"
  def password, do: "senha"
  def challenge, do: "LigaDasLegendas"

  def solve(input) do
    [_n | results] = String.split(input)
    {wins, losses} = best_result(results, {0,0}, {0,0})
    "#{wins + losses} #{wins} #{losses}\n"
  end

  def best_result([], _prev, best) do
    best
  end

  def best_result(["ganhou" | rest], {wins, losses}, best) do
    current = {wins+1, losses}
    if is_better(current, best) do
      best_result(rest, current, current)
    else
      best_result(rest, current, best)
    end
  end

  def best_result(["perdeu" | rest], {wins, losses}, best) do
    current = {wins, losses+1}
    best_result(rest, current, best)
  end

  def is_better({w1, l1}, {w2,l2}) do
    cond do
      w1-l1 > w2-l2 ->
        true
      w1-l1 < w2-l2 ->
        false
      w1 > w2 ->
        true
      true ->
        false
    end
  end
end

BoilerPlate.connect(LigaDasLegendas)
