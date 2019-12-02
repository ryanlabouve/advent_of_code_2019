defmodule AdventOfCode.Day2 do
  def run do
    with {:ok, file_string} <- File.read("lib/advent_of_code/day_2_input.txt") do
      file_string
      |> String.split(",")
      |> Enum.map(&String.to_integer(&1))
      |> run
    end
  end

  def run(prog) do
    # Initial replace at bottom of instructions
    prog =
      prog
      |> List.replace_at(1, 12)
      |> List.replace_at(2, 2)

    run(prog, 0)
  end

  @instruction_length 4

  def run(prog, cursor) do
    run(prog, cursor, Enum.slice(prog, cursor, 4))
  end

  def run(prog, cursor, [1, read_pos1, read_pos2, write_pos]) do
    v = Enum.at(prog, read_pos1) + Enum.at(prog, read_pos2)

    List.replace_at(prog, write_pos, v)
    |> run(cursor + @instruction_length)
  end

  def run(prog, cursor, [2, read_pos1, read_pos2, write_pos]) do
    v = Enum.at(prog, read_pos1) * Enum.at(prog, read_pos2)

    List.replace_at(prog, write_pos, v)
    |> run(cursor + @instruction_length)
  end

  def run(prog, _cursor, [99 | _]) do
    IO.inspect(prog)
    IO.puts("HALT")
  end

  def run(_prog, _cursor, _) do
    raise "Unknown Opcode"
  end

  # def swap(prog, pos1, pos2) do
  #   with val1 <- Enum.at(prog, pos1),
  #        val2 <- Enum.at(prog, pos2) do
  #     prog
  #     |> List.replace_at(pos1, val2)
  #     |> List.replace_at(pos2, val1)
  #   end
  # end
end
