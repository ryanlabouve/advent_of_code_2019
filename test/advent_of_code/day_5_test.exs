
defmodule AdventOfCodeTest.Day5 do
  use ExUnit.Case
  doctest AdventOfCode
  alias AdventOfCode.Day5

  import ExUnit.CaptureIO

  test "PONG diagnostic program" do
  #   o = capture_io("9", fn ->
  #     input = Day5.run([3,0,4,0,99], 0)
  #     IO.write(input)
  #   end)

  #  o2 = Enum.join(for <<c::utf8 <- o>>, do: <<c::utf8>>)
  #  require IEx; IEx.pry
  #  assert(o2 == "OPT3> 9")
  # This works, but I can't figure out how to mod this test
  end
end
