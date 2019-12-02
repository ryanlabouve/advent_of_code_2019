defmodule AdventOfCode.Day2 do
  @instruction_length 4

  def run_part_1 do
    IO.puts("Running part 1")
    run_from_file(12, 2)
  end

  def run_part_2() do
    IO.puts("Running part 2")

    # oh my. this is v rough
    # but ideally it executes the search in parallel
    # spawning off an ungoodly amount of backgroung processes
    # and simply erroring when it find what I'm looking for
    {v, noun, verb} =
      Enum.map(0..99, fn noun ->
        List.duplicate(noun, 99)
        |> Enum.zip(0..99)
      end)
      |> List.flatten()
      |> Enum.map(fn {noun, verb} ->
        fn -> run_part_2(noun, verb) end
      end)
      |> Enum.map(&Task.async(fn -> &1.() end))
      |> Enum.map(&Task.await/1)
      |> Enum.find(fn {v, _noun, _verb} -> v == 19_690_720 end)

    IO.puts("Found #{v} at n#{noun}v#{verb}")
  end

  def run_part_2(noun, verb) do
    # if Enum.at(run_from_file(noun, verb), 0) == 19_690_720 do
    #   raise "Found match at n#{noun}v#{verb}"
    # end
    {Enum.at(run_from_file(noun, verb), 0), noun, verb}
  end

  def run_from_file(noun \\ 12, verb \\ 2) do
    with {:ok, file_string} <- File.read("lib/advent_of_code/day_2_input.txt") do
      file_string
      |> String.split(",")
      |> Enum.map(&String.to_integer(&1))
      |> run_with_pos(noun, verb)
    end
  end

  def run_with_pos(prog, noun, verb) do
    prog =
      prog
      |> List.replace_at(1, noun)
      |> List.replace_at(2, verb)

    run(prog, 0)
  end

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
    # IO.inspect(prog)
    prog
  end

  def run(_prog, _cursor, [opcode | _]) do
    raise "Unknown Opcode #{opcode}"
  end
end
