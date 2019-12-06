require IEx

defmodule AdventOfCode.Day5 do
  def run do
    %{}
    |> attach_program()
    |> attach_stdin(5)
    |> attach_stdout()
    |> attach_buffer()
    |> attach_cursor(0)
    |> run()
  end

  def attach_program(machine) do
    program = with {:ok, file_string} <- File.read("lib/advent_of_code/day_5_input.txt") do
      file_string
      |> String.split(",")
      |> Stream.map(&String.to_integer/1)
      |> Stream.with_index
      |> Stream.map(fn {code, index} -> {index, code} end)
      |> Map.new
    end

    Map.put(machine, :program, program)
  end

  def attach_cursor(machine, cursor \\ 0), do: Map.put(machine, :cursor, cursor)
  def attach_stdin(machine, input \\ 1), do: Map.put(machine, :stdin, [input])
  def attach_stdout(machine), do: Map.put(machine, :stdout, [])
  def attach_buffer(machine), do: Map.put(machine, :buffer, [])

  def read_stdin(machine) do
    [head | tail] = machine.stdin
    {Map.put(machine, :stdin, tail), head}
  end

  defp read_at(machine, cursor), do: Map.fetch!(machine, cursor)

  def read_opcode(modes_and_opcode) do
    modes_and_opcode  = modes_and_opcode |> Integer.digits
    opcode = Enum.at(modes_and_opcode , -1)
    first_mode = Enum.at(modes_and_opcode , -3) || 0
    second_mode = Enum.at(modes_and_opcode , -4) || 0
    third_mode = Enum.at(modes_and_opcode , -5) || 0
    {opcode, [first_mode, second_mode, third_mode]}
  end

  def load_buffer(machine, number_of_instructions) do
    buffer = machine.cursor..(machine.cursor+number_of_instructions-1)
    |> Enum.to_list
    |> Enum.map(&read_at(machine.program, &1))

    %{ machine | cursor: machine.cursor + number_of_instructions, buffer: buffer }
  end

  def clear_buffer(machine), do: %{machine | buffer: []}

  def run(machine) do
    machine = load_buffer(machine, 1)
    {opcode, modes} = read_opcode(List.first machine.buffer)

    IO.puts("Running cursor #{machine.cursor}, o#{opcode}, m#{Enum.join modes, ","}")

    case opcode do
      1 -> machine |> load_buffer(3) |> add(modes) |> clear_buffer() |> run()
      2 -> machine |> load_buffer(3) |> mult(modes) |> clear_buffer() |> run()
      3 -> machine |> load_buffer(1) |> read() |> clear_buffer() |> run()
      4 -> machine |> load_buffer(1) |> write(modes)  |> clear_buffer() |> run()
      5 -> machine |> load_buffer(2) |> jump_if_true(modes) |> clear_buffer() |> run()
      6 -> machine |> load_buffer(2) |> jump_if_false(modes) |> clear_buffer() |> run()
      7 -> machine |> load_buffer(3) |> less_than(modes) |> clear_buffer() |> run()
      8 -> machine |> load_buffer(3) |> equals(modes) |> clear_buffer() |> run()
      9 -> halt(machine)
      99 -> halt(machine)
      _ -> unrecognized_opcode(machine, opcode)
    end
  end

  def jump_if_true(machine, [first_mode, second_mode, _]) do
    # TODO: e first parameter is non-zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
    [p1, p2] = machine.buffer

    v1 = lookup_value(machine, first_mode, p1)
    v2 = lookup_value(machine, second_mode, p2)

    case v1 != 0 do
      true -> %{machine | cursor: v2}
      false -> machine
    end
  end

  def jump_if_false(machine, [first_mode, second_mode, _]) do
    [p1, p2] = machine.buffer

    v1 = lookup_value(machine, first_mode, p1)
    v2 = lookup_value(machine, second_mode, p2)

    case v1 == 0 do
      true -> %{machine | cursor: v2}
      false -> machine
    end
  end

  def less_than(machine, [first_mode, second_mode, _]) do
    [p1, p2, p3] = machine.buffer

    v1 = lookup_value(machine, first_mode, p1)
    v2 = lookup_value(machine, second_mode, p2)

    case v1 < v2 do
      true -> write_to_pos(machine, p3, 1)
      false -> write_to_pos(machine, p3, 0)
    end
  end

  def equals(machine, [first_mode, second_mode, _]) do
    [p1, p2, p3] = machine.buffer

    v1 = lookup_value(machine, first_mode, p1)
    v2 = lookup_value(machine, second_mode, p2)

    case v1 == v2 do
      true -> write_to_pos(machine, p3, 1)
      false -> write_to_pos(machine, p3, 0)
    end
  end

  defp unrecognized_opcode(machine, opcode) do
    IO.puts "UNRECOGNIZED CODE"
    IO.puts "#{opcode}"
    IEx.pry
  end

  defp halt(machine) do
    # machine.stdout:
    IEx.pry
  end

  defp read_from_pos(machine, val) do
    case Map.fetch(machine.program, val) do
      {:ok, result} -> result
      :error -> IEx.pry
    end
  end

  defp write_to_pos(machine, pos, val), do: put_in(machine.program[pos], val)

  def lookup_value(machine, mode, val) do
    case mode do
      0 -> read_from_pos(machine, val)
      1 -> val
    end
  end

  def add(machine, [first_mode, second_mode, _]) do
    [p1, p2, p3] = machine.buffer

    v1 = lookup_value(machine, first_mode, p1)
    v2 = lookup_value(machine, second_mode, p2)

    IO.puts("  OP1, addr#{p3} <- (#{v1} + #{v2}) = #{v1 + v2}")
    write_to_pos(machine, p3, v1 + v2)
  end

  def mult(machine, [first_mode, second_mode, _]) do
    [p1, p2, p3] = machine.buffer

    v1 = lookup_value(machine, first_mode, p1)
    v2 = lookup_value(machine, second_mode, p2)

    IO.puts("  OP2, addr#{p3} <- (#{v1} * #{v2}) = #{v1 * v2}")
    write_to_pos(machine, p3, v1 * v2)
  end

  def read(machine) do
    [p1] = machine.buffer
    { machine, fresh_stdin} = read_stdin(machine)

    IO.puts("  OP3, #{p1} <- #{fresh_stdin}")
    write_to_pos(machine, p1, fresh_stdin)
  end

  def write(machine, [first_mode, _, _]) do
    [p1] = machine.buffer

    # v1 = lookup_value(machine, first_mode, p1)

    IO.puts("                                 OP4, (p#{p1}) ~> #{p1}")
    %{machine |
      stdout: machine.stdout ++ [{machine.cursor, read_from_pos(machine, p1)}]
    }
  end
end
