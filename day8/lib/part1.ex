defmodule PartOne do
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

    {seq, nodes_by_name}
    start = "AAA"
    seq = Seq.new(seq)

    find_terminal(nodes_by_name[start], seq, nodes_by_name, 0, "ZZZ")
  end

  def find_terminal(start, seq, nodes_by_name, curr_depth, terminal) do
    if start.name == terminal do
      {start, curr_depth}
    else
      {head, seq} = Seq.advance(seq)

      if head == "L" do
        find_terminal(nodes_by_name[start.left], seq, nodes_by_name, curr_depth + 1, terminal)
      else
        find_terminal(nodes_by_name[start.right], seq, nodes_by_name, curr_depth + 1, terminal)
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
