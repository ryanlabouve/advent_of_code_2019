defmodule AdventOfCode.Day4 do
  def run do
    valid_numbers =
      Enum.to_list(254_032..789_860)
      |> Enum.filter(&two_adjacent_digits/1)
      |> Enum.filter(&never_decreases/1)

    IO.inspect(valid_numbers)
    IO.puts(length(valid_numbers))
  end

  def two_adjacent_digits(number) do
    # Tried to do this with a capture group... but cannot
    # have capture group in lookbehind
    Enum.to_list(0..9)
    |> Enum.map(&~r/(?<!#{&1})#{&1}#{&1}(?!#{&1})/)
    |> Enum.map(fn r ->
      String.match?(Integer.to_string(number), r)
    end)
    |> Enum.any?()
  end

  def never_decreases(number) do
    {is_valid_number, _} =
      number
      |> Integer.to_string()
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce({true, 0}, fn el, {is_valid_number, current_max} ->
        case el >= current_max do
          true -> {is_valid_number, el}
          false -> {false, current_max}
        end
      end)

    is_valid_number
  end
end
