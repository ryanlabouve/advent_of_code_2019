defmodule AdventOfCodeTest.Day3 do
  use ExUnit.Case
  doctest AdventOfCode

  alias AdventOfCode.Day3

  test "Very basic case" do
    assert(Day3.run_basic() === 5)
  end

  test "Day3.run_sample" do
    assert(Day3.run_sample() === 135)
  end

  test "Day3.run_basic_min_signal_delay" do
    # 40 would be the unoptimized version
    assert(Day3.run_basic_min_signal_delay() === 30)
  end
end
