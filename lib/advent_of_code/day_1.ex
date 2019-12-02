defmodule AdventOfCode.Day1 do
  def run do
    with {:ok, file_string} <- File.read("lib/advent_of_code/day_1_input.txt") do
      file_string
      |> String.split("\n")
      |> Enum.map(&String.to_integer(&1))
      |> Enum.map(&fuel_required_to_launch(&1))
      |> Enum.sum()
    end
  end

  def fuel_required_to_launch(number) do
    Integer.floor_div(number, 3) - 2
  end
end
