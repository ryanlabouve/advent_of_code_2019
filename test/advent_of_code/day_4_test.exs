defmodule AdventOfCodeTest.Day4 do
  use ExUnit.Case
  doctest AdventOfCode

  alias AdventOfCode.Day4

  test "Day4.two_adjacent_digits with valid input" do
    assert(Day4.two_adjacent_digits(11) === true)
    assert(Day4.two_adjacent_digits(1_234_556_789) === true)
    assert(Day4.two_adjacent_digits(1_238_477) === true)
  end

  test "Day4.two_adjacent_digits with invalid input" do
    assert(Day4.two_adjacent_digits(12345) === false)
    assert(Day4.two_adjacent_digits(18_181_818) === false)
  end

  test "Day4.two_adjacent_digits with invalid input from part 2" do
    # Cannot be match as part of larger group
    assert(Day4.two_adjacent_digits(12_345_554_321) === false)
  end

  test "Day4.two_adjacent_digits with valid input from part 2" do
    # meets the criteria (even though 1 is repeated more than twice, it still contains a double 22).
    assert(Day4.two_adjacent_digits(111_122) === true)
  end

  test "Day4.never_decreases with valid input" do
    assert(Day4.never_decreases(1_111_111) === true)
    assert(Day4.never_decreases(1234) === true)
  end

  test "Day4.never_decreases with invalid input" do
    assert(Day4.never_decreases(90_111_111) === false)
    assert(Day4.never_decreases(111_181) === false)
  end
end
