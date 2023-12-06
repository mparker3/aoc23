defmodule Day6 do
  def part_one do
    # read lines from file
    File.read!("input.txt")
    |> String.split("\n")
    # drop last empty line
    |> Enum.drop(-1)
    |> Enum.map(fn line -> String.split(line, ~r/\s+/) end)
    |> Enum.map(fn [_ | x] -> x end)
    |> Enum.map(fn x -> Enum.map(x, &String.to_integer/1) end)
    |> Enum.zip()
    |> Enum.map(fn x -> get_zeroes(x) end)
    |> Enum.map(fn {x, y} -> {Float.ceil(x), Float.floor(y)} end)
    |> Enum.map(fn {x, y} -> y - x + 1 end)
    |> Enum.reduce(1, &Kernel.*/2)
    |> trunc()
  end

  def part_two do
    # read lines from file
    File.read!("input.txt")
    |> String.split("\n")

    # drop last empty line
    |> Enum.drop(-1)
    |> Enum.map(fn line -> String.split(line, ~r/\s+/) end)
    |> Enum.map(fn [_ | x] -> [x] end)
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(fn x -> [x] end)
    |> Enum.zip()
    |> Enum.map(fn x -> get_zeroes(x) end)
    |> Enum.map(fn {x, y} -> {Float.ceil(x), Float.floor(y)} end)
    |> Enum.map(fn {x, y} -> y - x + 1 end)
    |> Enum.reduce(1, &Kernel.*/2)
    |> trunc()
  end

  # distance traveled is equal to the total time of the race - time the button was held
  # , * the time the button is held (which was also the speed)
  def get_zeroes({total_time, record}) do
    # x^2 * total_time(x) - record
    a = -1
    b = total_time
    # we have to _beat_ the record. cheap hack. 
    c = -1 * record - 0.00000000001
    # quadratic formula
    # x = (-b +- sqrt(b^2 - 4ac)) / 2a
    plus_zero = (-b + :math.sqrt(b * b - 4 * a * c)) / (2 * a)
    minus_zero = (-b - :math.sqrt(b * b - 4 * a * c)) / (2 * a)
    {plus_zero, minus_zero}
  end
end
