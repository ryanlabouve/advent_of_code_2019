require IEx

defmodule AdventOfCode.Day3 do
  # find the intersect point closest to central port
  def run do
    with {:ok, file_string} <- File.read("lib/advent_of_code/day_3_input.txt") do
      instruction_set =
        file_string
        |> String.split("\n")
        |> Enum.map(&String.split(&1, ","))

      %{}
      |> run_instruction_set(Enum.at(instruction_set, 0), new_wire(1))
      |> run_instruction_set(Enum.at(instruction_set, 1), new_wire(2))
      |> board_interesection_cords()
    end
  end

  def new_wire(marker) do
    %{
      position: {0, 0},
      marker: marker,
      steps: 0
    }
  end

  def run_sample do
    with {:ok, file_string} <- File.read("lib/advent_of_code/day_3_input_sample.txt") do
      instruction_set =
        file_string
        |> String.split("\n")
        |> Enum.map(&String.split(&1, ","))

      intersection_points =
        %{}
        |> run_instruction_set(Enum.at(instruction_set, 0), new_wire(1))
        |> run_instruction_set(Enum.at(instruction_set, 1), new_wire(2))
        |> board_interesection_cords()

      intersection_points
      |> Enum.map(fn {{x, y}, _} ->
        abs(x) + abs(y)
      end)
      |> Enum.min()
    end
  end

  def run_basic do
    instruction_set = ["D5"]
    instruction_set_2 = ["R1", "D5", "L1"]

    wire_1 = new_wire(1)
    wire_2 = new_wire(2)

    intersection_points =
      %{}
      |> run_instruction_set(instruction_set, wire_1)
      |> run_instruction_set(instruction_set_2, wire_2)
      |> board_interesection_cords()

    intersection_points
    |> Enum.map(fn {{x, y}, _} ->
      abs(x) + abs(y)
    end)
    |> Enum.min()
  end

  def run_basic_min_signal_delay do
    instruction_set = ["U8", "R5", "D5", "L4"]
    instruction_set_2 = ["R8", "U5", "L5", "D3"]

    wire_1 = new_wire(1)
    wire_2 = new_wire(2)

    intersection_points =
      %{}
      |> run_instruction_set(instruction_set, wire_1)
      |> run_instruction_set(instruction_set_2, wire_2)
      |> board_interesection_cords()

    intersection_points
  end

  ####################################
  # Should be private methods below
  ####################################

  def run_instruction_set(board, instruction_set, wire) do
    {board, _wire} =
      Enum.reduce(instruction_set, {board, wire}, fn el, acc ->
        {board, wire} = acc
        write_move(board, wire, el)
      end)

    board
  end

  def board_interesection_cords(board) do
    intersection_points = :maps.filter(fn _, v -> length(Enum.uniq(v)) == 2 end, board)
    intersection_points
  end

  def write_move(board, wire, instruction) do
    direction = String.slice(instruction, 0..0)
    number = String.slice(instruction, 1..-1) |> String.to_integer()

    write_move(board, wire, direction, number)
  end

  defp update_board(board, wire) do
    Map.update(board, wire.position, [wire.marker], fn x ->
      x ++ [wire.marker]
    end)
  end

  def write_move(board, wire, _, 0), do: {board, wire}

  def write_move(board, wire, "D", number) do
    wire = Map.update(wire, :position, {0, 0}, fn {x, y} -> {x, y - 1} end)
    write_move(update_board(board, wire), wire, "D", number - 1)
  end

  def write_move(board, wire, "U", number) do
    wire = Map.update(wire, :position, {0, 0}, fn {x, y} -> {x, y + 1} end)
    write_move(update_board(board, wire), wire, "U", number - 1)
  end

  def write_move(board, wire, "L", number) do
    wire = Map.update(wire, :position, {0, 0}, fn {x, y} -> {x - 1, y} end)
    board = Map.update(board, wire.position, [wire.marker], &(&1 ++ [wire.marker]))
    write_move(update_board(board, wire), wire, "L", number - 1)
  end

  def write_move(board, wire, "R", number) do
    wire = Map.update(wire, :position, {0, 0}, fn {x, y} -> {x + 1, y} end)
    write_move(update_board(board, wire), wire, "R", number - 1)
  end
end
