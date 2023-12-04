require IEx

defmodule Day4 do
  def part_one do
    File.stream!("sample.txt")
    |> Enum.to_list()
    |> Enum.map(fn x -> String.split(x, ":") end)
    |> Enum.map(fn [_, res] -> res end)
    |> Enum.map(fn x -> String.trim(x) end)
    |> Enum.map(fn x -> String.split(x, " | ") end)
    |> Enum.map(fn [winning, mine] -> {String.split(winning, " "), String.split(mine, " ")} end)
    |> Enum.map(fn {winning, mine} -> 
      [
        Enum.filter(winning, fn x -> x != "" end)
        |> Enum.map(fn x -> String.to_integer(x) end),
        Enum.filter(mine, fn x -> x != "" end)
        |> Enum.map(fn x -> String.to_integer(x) end),
      ] 
    end)
    |> Enum.map(fn [winning , mine] -> {MapSet.new(winning), MapSet.new(mine)} end)
    |> Enum.map(fn {winning, mine} -> MapSet.intersection(winning, mine) end)
    |> Enum.map(fn x -> MapSet.size(x) end)
    |> Enum.filter(fn x -> x > 0 end)
    |> Enum.map(fn x -> x - 1 end)
    |> Enum.map(fn x -> 2 ** x end)
    |> Enum.reduce(0, fn x, acc -> x + acc end)
  end

  def part_two do
    games = File.stream!("input.txt")
    |> Enum.to_list()
    |> Enum.map(fn x -> String.split(x, ":") end)
    |> Enum.map(fn [gameno, x] -> {gameno, String.trim(x)} end)
    |> Enum.map(fn {gameno, x} -> {gameno, String.split(x, " | ")} end)
    |> Enum.map(fn {gameno, [winning, mine]} -> {String.split(gameno, " "), {String.split(winning, " "), String.split(mine, " ")}} end)
    |> Enum.map(fn {gameno, {winning, mine}} -> 
      {
        Enum.filter(gameno, fn x -> x not in ["Card", ""] end)
        |> hd()
        |> String.to_integer(),
        Enum.filter(winning, fn x -> x != "" end)
        |> Enum.map(fn x -> String.to_integer(x) end),
        Enum.filter(mine, fn x -> x != "" end)
        |> Enum.map(fn x -> String.to_integer(x) end),
      } 
    end)
    |> Enum.map(fn {gameno, winning , mine} -> {gameno, MapSet.new(winning), MapSet.new(mine)} end)
    |> Enum.map(fn {gameno, winning, mine} -> {gameno, MapSet.intersection(winning, mine)} end)
    |> Enum.map(fn {gameno, x} -> {gameno, MapSet.size(x)} end)
    {games, Enum.into(games, %{})}
  end

  def rec([], _) do [] end
  def rec({games, game_map}) do
    # get next iteration of games
    next_games = Enum.filter(games, fn {_, x} -> x > 0 end)
    |> Enum.map(fn {gameno, how_many} ->
      gameno + 1..gameno + how_many
      |> Enum.map(fn x -> {x, game_map[x]} end)
    end)
    |> List.flatten()
    if Enum.empty?(next_games) do
      games
    else
      new_games = rec({next_games, game_map})
      games ++ new_games
    end
  end

  def solve() do
   part_two()
   |> rec()
   |> Enum.count()
  end
end


