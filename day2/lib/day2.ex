require IEx

defmodule Day2 do
  def games do
    maxes = %{"red" => 12, "green" => 13, "blue" => 14}
    File.stream!("input.txt")
    |> Enum.map(fn x -> String.split(x, ":") end)
    |> Enum.map(fn [gameno, game] ->
      [_, game_number] = String.split(gameno, " ")
      {String.to_integer(game_number), game}
    end)
    |> Enum.map(fn {gameno, game} ->
      {gameno, String.split(game, ";")}
    end)
    |> Enum.map(fn {gameno, turns} -> 
      {gameno, Enum.map(turns, fn x -> 
        String.split(x, ",") |> Enum.map(&String.trim/1) 
      end)}
    end)
    |> Enum.map(fn {gameno, turns} ->
      res = Enum.map(turns, fn turn ->
        Enum.map(turn, fn entry -> 
          [num, color] = String.split(entry, " ")
          {String.to_integer(num), color}
        end)
        |> Enum.all? (fn {num, color} -> 
          num <= maxes[color]
        end)
      end)
      {gameno, res}
    end)
    |> Enum.map(fn {gameno, turns} ->
      {gameno, Enum.all?(turns, fn x -> x end)}
    end)
    |> Enum.filter(fn {gameno, res} -> res end)
    |> Enum.map(fn {gameno, res} -> gameno end)
    |> Enum.reduce(0, fn x, acc -> x + acc end)
  end
  

  def ptwo do
    File.stream!("input.txt")
    |> Enum.map(fn x -> String.split(x, ":") end)
    |> Enum.map(fn [gameno, game] ->
      [_, game_number] = String.split(gameno, " ")
      {String.to_integer(game_number), game}
    end)
    |> Enum.map(fn {gameno, game} ->
      {gameno, String.split(game, ";")}
    end)
    |> Enum.map(fn {gameno, turns} -> 
      {gameno, Enum.map(turns, fn x -> 
        String.split(x, ",") |> Enum.map(&String.trim/1) 
      end)}
    end)
    |> Enum.map(fn {gameno, turns} ->
      res = Enum.reduce(turns, %{"red" => [], "green" => [], "blue" => []}, fn turn, acc ->
        Enum.reduce(turn, acc, fn entry, acc2 ->
          [num_str, color] = String.split(entry, " ")
          num = String.to_integer(num_str)
          Map.update(acc2, color, [num], fn existing_nums -> [num | existing_nums] end)
        end)
      end)
      # get the max of each color
      res = Enum.map(res, fn {color, nums} -> 
        {color, Enum.max(nums)}
      end)
      |> Enum.map(fn {color, num} -> 
        num
      end)
      |> Enum.reduce(1, fn x, acc -> x * acc end)
      res
    end)
    |> Enum.reduce(0, fn x, acc -> x + acc end)
  end
  

end
