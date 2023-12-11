require IEx

defmodule Pipe do
  # these are bidirectional! just easier shorthand and better mental model
  defstruct in_pipe: nil, out_pipe: nil, row: nil, col: nil, char: nil

  def new(row, col, char) do
    %Pipe{row: row, col: col, char: char}
  end
end

defmodule PartOne do
  def solve do
    grid =
      File.stream!("input.txt")
      |> Stream.map(&String.trim/1)
      |> Enum.map(&String.graphemes/1)

    result =
      Enum.reduce(Enum.with_index(grid), %{}, fn {row, row_index}, acc ->
        Enum.reduce(Enum.with_index(row), acc, fn {value, col_index}, acc_inner ->
          Map.put(acc_inner, {row_index, col_index}, Pipe.new(row_index, col_index, value))
        end)
      end)

    {_, start} = result |> Enum.find(fn {_, pipe} -> pipe.char == "S" end)
    curr = result |> Map.get({start.row + 1, start.col})

    build_path(result, start, curr)
    |> length()
    |> Kernel.div(2)
  end

  def build_path(grid, prev, curr) do
    case get_next_pipe(prev, curr) do
      {nil, nil} ->
        []

      {row, col} ->
        [curr | build_path(grid, curr, grid |> Map.get({row, col}))]
    end
  end

  def get_next_pipe(prev, curr) do
    case curr.char do
      "S" ->
        {nil, nil}

      "|" ->
        case curr.row - prev.row do
          1 ->
            {curr.row + 1, curr.col}

          _ ->
            {curr.row - 1, curr.col}
        end

      "-" ->
        case curr.col - prev.col do
          1 ->
            {curr.row, curr.col + 1}

          _ ->
            {curr.row, curr.col - 1}
        end

      "L" ->
        case curr.row - prev.row do
          0 ->
            {curr.row - 1, curr.col}

          _ ->
            {curr.row, curr.col + 1}
        end

      "F" ->
        case curr.row - prev.row do
          0 ->
            {curr.row + 1, curr.col}

          _ ->
            {curr.row, curr.col + 1}
        end

      "7" ->
        case curr.row - prev.row do
          0 ->
            {curr.row + 1, curr.col}

          _ ->
            {curr.row, curr.col - 1}
        end

      "J" ->
        case curr.row - prev.row do
          0 ->
            {curr.row - 1, curr.col}

          _ ->
            {curr.row, curr.col - 1}
        end
    end
  end
end
