require IEx

defmodule PartTwo do
  def solve do
    [[seq], _, node_strings] =
      File.stream!("input.txt")
      |> Enum.map(&String.trim/1)
      |> Enum.to_list()
      |> Enum.chunk_by(fn x -> x == "" end)

    nodes_by_name =
      node_strings
      |> Enum.map(&parse_node/1)
      |> Enum.map(fn node -> {node.name, node} end)
      |> Enum.into(%{})

    seq = Seq.new(seq)

    nodes_by_name
    |> Enum.filter(fn {name, _} ->
      [_, char | _] = String.split(String.reverse(name), "")
      char == "A"
    end)
    |> Enum.map(fn {name, _} -> name end)
    |> Enum.map(fn start ->
      find_terminal(nodes_by_name[start], seq, nodes_by_name, 0)
    end)
    |> Enum.map(fn {_, depth} -> depth end)
    |> Enum.reduce(1, fn x, acc ->
      x * acc / Integer.gcd(x, trunc(acc))
    end)
    |> trunc
  end

  def find_terminal(start, seq, nodes_by_name, curr_depth) do
    res = String.split(String.reverse(start.name), "")
    # IEx.pry()

    case res do
      ["", "Z" | _] ->
        {start, curr_depth}

      _ ->
        {head, seq} = Seq.advance(seq)

        if head == "L" do
          find_terminal(nodes_by_name[start.left], seq, nodes_by_name, curr_depth + 1)
        else
          find_terminal(nodes_by_name[start.right], seq, nodes_by_name, curr_depth + 1)
        end
    end
  end

  def parse_node(node_string) do
    [name, children] = String.split(node_string, " = ")
    [left, right] = String.split(children, ", ")
    left = String.replace(left, "(", "")
    right = String.replace(right, ")", "")
    Tree.Node.new(name, left, right)
  end
end

defmodule Tree.Node do
  defstruct name: "", left: nil, right: nil

  def new(name, left, right) do
    %Tree.Node{name: name, left: left, right: right}
  end
end

defmodule Seq do
  defstruct seq: []

  def new(seq) do
    %Seq{seq: String.split(seq, "") |> Enum.filter(&(&1 != ""))}
  end

  def advance(%Seq{seq: seq}) do
    [head | rest] = seq
    rest = rest ++ [head]
    {head, %Seq{seq: rest}}
  end
end
