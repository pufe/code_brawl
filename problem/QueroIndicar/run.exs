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
  def challenge, do: "QueroIndicar"

  def solve(input) do
    [_n | users] = String.split(input, "\n", trim: true)
    users
    |> Enum.map(&parse_user/1)
    |> Enum.into(%{}, fn u ->
      {u.name, u}
    end)
    |> process_indications()
    |> Enum.sort_by(fn {name, u} ->
      {-u.total, name} # inverte o sinal do total para colocar o maior na frente
    end)
    |> Enum.with_index
    |> Enum.map(&print_user/1)
    |> Enum.join("")
  end

  def parse_user(user) do
    [name, indicator, one, five] = String.split(user)
    score = 0
    score = if one=="true", do: score+1, else: score
    score = if five=="true", do: score+5, else: score
    %{name: name, indicator: indicator, score: score, total: score}
  end

  def process_indications(users) do
    list = Enum.into(users, [], fn {_name, u} -> u end)
    process_indications(list, users)
  end

  def process_indications([], users) do
    users
  end

  def process_indications([first | rest], users) do
    indicator = Map.get(users, first.indicator)

    if indicator do
      users = update_in(users[indicator.name].total, fn _current ->
            indicator.total+first.score
      end)
      process_indications(rest, users)
    else
      process_indications(rest, users)
    end
  end

  def print_user({{_, user}, index}) do
    "#{index+1} #{user.name} #{user.total}\n"
  end
end

BoilerPlate.connect(Run)
