defmodule AdventOfCode.Day5 do
  @instruction_length 4

  def run do
    with {:ok, file_string} <- File.read("lib/advent_of_code/day_5_input.txt") do
      file_string
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer(&1))
      |> run(0)
    end
  end

  def run(prog, cursor) do
    instruction =  Enum.slice(prog, cursor, 4)
    mode_and_code = Integer.digits(Enum.at(instruction, 0))


    opcode = Enum.at(mode_and_code, -1)
    first_pos_code = Enum.at(mode_and_code, -2) || 0
    second_pos_code = Enum.at(mode_and_code, -3) || 0
    third_pos_code = Enum.at(mode_and_code, -4) || 0

    run(prog, cursor, opcode, instruction, {first_pos_code, second_pos_code, third_pos_code})
  end

  # decipher op code
  # read or put value
  # call methods below


  # conver to "val1 + val2"
  def run(prog, cursor, 1, [_, first_val, second_val, write_pos], {first_pos_code, second_pos_code, _}) do
    v1 = case first_pos_code do
      0 -> Enum.at(prog, first_val)
      1 -> first_val
    end

    v2 = case second_pos_code do
      0 -> Enum.at(prog, second_val)
      1 -> second_val
    end

    List.replace_at(prog, write_pos, v1 + v2)
    |> run(cursor + @instruction_length)
  end

  def run(prog, cursor, 2, [_, first_val, second_val, write_pos], {first_pos_code, second_pos_code, _}) do
    v1 = case first_pos_code do
      0 -> Enum.at(prog, first_val)
      1 -> first_val
    end

    v2 = case second_pos_code do
      0 -> Enum.at(prog, second_val)
      1 -> second_val
    end

    List.replace_at(prog, write_pos, v1 * v2)
    |> run(cursor + @instruction_length)
  end

  def run(prog, cursor, 3, [_, write_pos| _ ], _) do
    {v, _} = Integer.parse(IO.gets("OPT3> "))

    List.replace_at(prog, write_pos, v)
    |> run(cursor + 2)
  end

  def run(prog, cursor, 4, [_, read_pos| _ ], _) do
     IO.puts("OPT4> #{Enum.at(prog, read_pos)}")

    run(prog, cursor + 2)
  end


  def run(prog, _cursor, [99 | _]) do
    IO.inspect("HALT")
    prog
  end

  def run(_prog, _cursor, [opcode | _]) do
    raise "Unknown Opcode #{opcode}"
  end
end
