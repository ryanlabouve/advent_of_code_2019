defmodule AdventOfCode.Day3 do
  # find the intersect point closest to central port
  def run do
    with {:ok, file_string} <- File.read("lib/advent_of_code/day_3_input.txt") do
      instruction_set =
        file_string
        |> String.split("\n")
        |> Enum.map(&String.split(&1, ","))

      board(2000)
      |> run_instruction_set(Enum.at(instruction_set, 0), new_wire(1))
      |> run_instruction_set(Enum.at(instruction_set, 1), new_wire(2))
      |> shortest_board_distance()
    end
  end

  def new_wire(marker) do
    %{
      position: {0, 0},
      marker: marker
    }
  end

  def run_sample do
    with {:ok, file_string} <- File.read("lib/advent_of_code/day_3_input_sample.txt") do
      instruction_set =
        file_string
        |> String.split("\n")
        |> Enum.map(&String.split(&1, ","))

      # 159
      board(500)
      |> run_instruction_set(Enum.at(instruction_set, 0), new_wire(1))
      |> run_instruction_set(Enum.at(instruction_set, 1), new_wire(2))
      |> shortest_board_distance()
    end
  end

  def run_basic do
    instruction_set = ["D5"]
    instruction_set_2 = ["R1", "D5", "L1"]

    board(10)
    |> run_instruction_set(instruction_set, new_wire(1))
    |> run_instruction_set(instruction_set_2, new_wire(2))
    |> shortest_board_distance()
  end

  def run_instruction_set(board, instruction_set, wire) do
    {board, _wire} =
      Enum.reduce(instruction_set, {board, wire}, fn el, acc ->
        {board, wire} = acc
        write_move(board, wire, el)
      end)

    board
  end

  def shortest_board_distance(board) do
    a = :maps.filter(fn _, v -> length(v) > 0 end, board)
    b = :maps.filter(fn _, v -> length(v) > 1 end, board)
    c = :maps.filter(fn _, v -> length(Enum.uniq(v)) == 2 end, board)

    d =
      Enum.map(c, fn {{x, y}, _} ->
        abs(x) + abs(y)
      end)

    answer = d |> Enum.min()

    require IEx
    IEx.pry()
  end

  def write_move(board, wire, instruction) do
    direction = String.slice(instruction, 0..0)
    number = String.slice(instruction, 1..-1) |> String.to_integer()

    write_move(board, wire, direction, number)
  end

  def write_move(board, wire, "D", number) do
    if number === 0 do
      {board, wire}
    else
      wire = Map.update(wire, :position, {0, 0}, fn {x, y} -> {x, y - 1} end)
      board = Map.update(board, wire.position, [], &(&1 ++ [wire.marker]))
      write_move(board, wire, "D", number - 1)
    end
  end

  def write_move(board, wire, "U", number) do
    if number === 0 do
      {board, wire}
    else
      wire = Map.update(wire, :position, {0, 0}, fn {x, y} -> {x, y + 1} end)
      board = Map.update(board, wire.position, [], &(&1 ++ [wire.marker]))
      write_move(board, wire, "U", number - 1)
    end
  end

  def write_move(board, wire, "L", number) do
    if number === 0 do
      {board, wire}
    else
      wire = Map.update(wire, :position, {0, 0}, fn {x, y} -> {x - 1, y} end)
      board = Map.update(board, wire.position, [], &(&1 ++ [wire.marker]))
      write_move(board, wire, "L", number - 1)
    end
  end

  def write_move(board, wire, "R", number) do
    if number === 0 do
      {board, wire}
    else
      wire = Map.update(wire, :position, {0, 0}, fn {x, y} -> {x + 1, y} end)
      board = Map.update(board, wire.position, [], &(&1 ++ [wire.marker]))
      write_move(board, wire, "R", number - 1)
    end
  end

  def calculate_distance(_board) do
  end

  def board(size \\ 1000) do
    t =
      for x <- (size * -1)..size,
          y <- (size * -1)..size,
          do: {x, y}

    t
    |> Enum.reduce(%{}, fn el, acc ->
      Map.put(acc, el, [])
    end)
  end
end
