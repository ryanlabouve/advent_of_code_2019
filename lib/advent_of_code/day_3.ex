require IEx

defmodule AdventOfCode.Day3 do
  # find the intersect point closest to central port
  def run do
    with {:ok, file_string} <- File.read("lib/advent_of_code/day_3_input.txt") do
      instruction_set =
        file_string
        |> String.split("\n")
        |> Enum.map(&String.split(&1, ","))

      {board, _wire} =
        {%{}, new_wire(1)}
        |> run_instruction_set(Enum.at(instruction_set, 0))

      {board, _wire} =
        {board, new_wire(2)}
        |> run_instruction_set(Enum.at(instruction_set, 1))

      intersection_points = board_interesection_cords(board)

      intersection_points
      |> Enum.map(fn {{x, y}, _} ->
        abs(x) + abs(y)
      end)
      |> Enum.min()
    end
  end

  # TODO: move to struct
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

      {board, _wire} =
        {%{}, new_wire(1)}
        |> run_instruction_set(Enum.at(instruction_set, 0))

      {board, _wire} =
        {board, new_wire(2)}
        |> run_instruction_set(Enum.at(instruction_set, 1))

      intersection_points = board_interesection_cords(board)

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

    {board, _wire} =
      {%{}, wire_1}
      |> run_instruction_set(instruction_set)

    {board, _wire} =
      {board, wire_2}
      |> run_instruction_set(instruction_set_2)

    intersection_points = board_interesection_cords(board)

    intersection_points
    |> Enum.map(fn {{x, y}, _} ->
      abs(x) + abs(y)
    end)
    |> Enum.min()
  end

  def run_m_distance([instruction_set, instruction_set_2]) do
  end

  def run_basic_min_signal_delay() do
    run_min_signal_delay([
      ["R8", "U5", "L5", "D3"],
      ["U7", "R6", "D4", "L4"]
    ])
  end

  def run_min_signal_delay_sample_1 do
    with {:ok, file_string} <- File.read("lib/advent_of_code/day_3_part_2_sample.txt") do
      file_string
      |> String.split("\n")
      |> Enum.map(&String.split(&1, ","))
      |> run_min_signal_delay
    end
  end

  def run_min_signal_delay_real do
    with {:ok, file_string} <- File.read("lib/advent_of_code/day_3_input.txt") do
      file_string
      |> String.split("\n")
      |> Enum.map(&String.split(&1, ","))
      |> run_min_signal_delay
    end
  end

  # @tag timeout: :infinity
  def run_min_signal_delay([instruction_set, instruction_set_2]) do
    wire_1 = new_wire(1)
    wire_2 = new_wire(2)

    {board, wire_1} =
      {%{}, wire_1}
      |> run_instruction_set(instruction_set)

    {board, wire_2} =
      {board, wire_2}
      |> run_instruction_set(instruction_set_2)

    intersection_points = board_interesection_cords(board)

    a =
      :maps.map(
        fn coord, [wire_1_marker, wire_2_marker] ->
          [
            Enum.find_index(wire_1.history, &(coord == &1)),
            Enum.find_index(wire_2.history, &(coord == &1))
          ]
        end,
        intersection_points
      )

    # IEx.pry()
    b = :maps.map(fn _, [x, y] -> x + y end, a)

    (Map.values(b) |> Enum.min()) + 2
  end

  ####################################
  # Should be private methods below
  ####################################

  def run_instruction_set({board, wire}, instruction_set) do
    {board, wire} =
      Enum.reduce(instruction_set, {board, wire}, fn el, acc ->
        {board, wire} = acc
        write_move(board, wire, el)
      end)

    {board, wire}
  end

  def board_interesection_cords(board) do
    uniquifyed_plots_board = :maps.map(fn _, v -> Enum.uniq(v) end, board)
    intersection_points = :maps.filter(fn _, v -> length(v) == 2 end, uniquifyed_plots_board)
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

    wire =
      Map.update(wire, :history, [wire.position], fn history_list ->
        history_list ++ [wire.position]
      end)

    write_move(update_board(board, wire), wire, "D", number - 1)
  end

  def write_move(board, wire, "U", number) do
    wire = Map.update(wire, :position, {0, 0}, fn {x, y} -> {x, y + 1} end)

    wire =
      Map.update(wire, :history, [wire.position], fn history_list ->
        history_list ++ [wire.position]
      end)

    write_move(update_board(board, wire), wire, "U", number - 1)
  end

  def write_move(board, wire, "L", number) do
    wire = Map.update(wire, :position, {0, 0}, fn {x, y} -> {x - 1, y} end)

    wire =
      Map.update(wire, :history, [wire.position], fn history_list ->
        history_list ++ [wire.position]
      end)

    board = Map.update(board, wire.position, [wire.marker], &(&1 ++ [wire.marker]))
    write_move(update_board(board, wire), wire, "L", number - 1)
  end

  def write_move(board, wire, "R", number) do
    wire = Map.update(wire, :position, {0, 0}, fn {x, y} -> {x + 1, y} end)

    wire =
      Map.update(wire, :history, [wire.position], fn history_list ->
        history_list ++ [wire.position]
      end)

    write_move(update_board(board, wire), wire, "R", number - 1)
  end
end
