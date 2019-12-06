require IEx
defmodule AdventOfCode.Day6 do
  def run_sample, do: run("lib/advent_of_code/day_6_sample_input.txt")
  def run(f \\ "lib/advent_of_code/day_6_input.txt") do
    with {:ok, file_string} <- File.read(f) do
      file_string
      |> String.split("\n")
      |> build_tree
    end
  end

  def build_tree([head | nodes], tree \\ []) do

    [o, oo] = String.split(head, ")")

    IEx.pry
    case List.flatten(tree) do
      {o, current_list} -> tree ++ [{o, current_list ++ [oo]}]

    end

    build_tree(nodes, tree)
  end

end

