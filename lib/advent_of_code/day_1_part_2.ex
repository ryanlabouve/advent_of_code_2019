defmodule AdventOfCode.Day1Part2 do
  def run do
    with {:ok, file_string} <- File.read("lib/advent_of_code/day_1_input.txt") do
      file_string
      |> String.split("\n")
      |> Enum.map(&String.to_integer(&1))
      |> Enum.map(&fuel_required_to_launch(&1))
      |> Enum.sum()
    end
  end

  def fuel_required_to_launch(mass) do
    fuel_to_launch = Integer.floor_div(mass, 3) - 2

    cond do
      fuel_to_launch > 0 -> fuel_to_launch + fuel_required_to_launch(fuel_to_launch)
      fuel_to_launch <= 0 -> 0
    end
  end
end
