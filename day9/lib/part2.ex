require IEx

defmodule PartTwo do
  def solve do
    File.stream!("input.txt")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn x ->
      Enum.map(
        x,
        &String.trim/1
      )
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn x ->
      [x] ++ gen_next(x)
    end)
    |> Enum.map(fn x -> Enum.map(x, fn y -> hd(y) end) end)
    |> Enum.map(&reduce_subtract/1)
    |> Enum.sum()
  end

  def reduce_subtract(list) do
    case list do
      [x] -> x
      _ -> hd(list) - reduce_subtract(tl(list))
    end
  end

  def gen_next(series) do
    # given series, generate deriv series
    diffs =
      Enum.chunk_every(series, 2, 1, :discard)
      |> Enum.map(fn [x, y] ->
        y - x
      end)

    # return diffs if all zeroes: base case, we cannot derivate further
    if Enum.all?(diffs, fn x -> x == 0 end) do
      [diffs]
    else
      # recursively generate the next series
      next = gen_next(diffs)
      # return a list of this element and the next series
      # append each element in `next` to `diffs`
      [diffs | next]
    end
  end
end
