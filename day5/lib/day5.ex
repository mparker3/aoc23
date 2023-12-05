require IEx

defmodule Day5 do
  def part_one do
    # read the first line of the file into a string
    input =
      File.read!("input.txt")
      |> String.split("\n")

    [seed_string | rest] = input
    [_ | seed_strings] = String.split(seed_string, " ")
    seeds = Enum.map(seed_strings, fn x -> String.to_integer(x) end)

    [_ | rest] = rest

    # I will likely regret this later.
    {seed_to_soil, [_ | rest]} = Enum.split_while(rest, fn line -> line != "" end)
    {soil_to_fertilizer, [_ | rest]} = Enum.split_while(rest, fn line -> line != "" end)
    {fertilizer_to_water, [_ | rest]} = Enum.split_while(rest, fn line -> line != "" end)
    {water_to_light, [_ | rest]} = Enum.split_while(rest, fn line -> line != "" end)
    {light_to_temperature, [_ | rest]} = Enum.split_while(rest, fn line -> line != "" end)

    {temperature_to_humidity, [_ | humidity_to_location]} =
      Enum.split_while(rest, fn line -> line != "" end)

    map_arrays = [
      seed_to_soil,
      soil_to_fertilizer,
      fertilizer_to_water,
      water_to_light,
      light_to_temperature,
      temperature_to_humidity,
      humidity_to_location
    ]

    transforms = Enum.map(map_arrays, fn map_array -> toTransform(map_array) end)

    # iteratively apply transform for each value in list
    Enum.map(seeds, fn x ->
      Enum.reduce(transforms, x, fn transform, value ->
        StepTransform.transform(transform, value)
      end)
    end)
    # get the minimum
    |> Enum.min()
  end

  def toTransform(input) do
    [name | map_strings] = input

    maps =
      Enum.map(map_strings, fn map_string ->
        String.split(map_string, " ")
        |> MappingRange.new()
      end)

    StepTransform.new(name, maps)
  end
end

defmodule MappingRange do
  defstruct source_start: 0, dest_start: 0, length: 0

  def new([dest_start, source_start, length]) do
    # convert to ints
    %MappingRange{
      source_start: String.to_integer(source_start),
      dest_start: String.to_integer(dest_start),
      length: String.to_integer(length)
    }
  end

  def in_range?(mapping_range, value) do
    value >= mapping_range.source_start &&
      value < mapping_range.source_start + mapping_range.length
  end

  def transform(mapping_range) do
    fn x -> x + mapping_range.dest_start - mapping_range.source_start end
  end
end

defmodule StepTransform do
  defstruct name: "unknown map", range_pairs: []

  def new(name, range_pairs) do
    %StepTransform{name: name, range_pairs: range_pairs}
  end

  def transform(step_transform, value) do
    # find the mapping range that contains the value. if none exists, return :no_match
    mapping_range =
      Enum.find(step_transform.range_pairs, :no_match, fn range_pair ->
        MappingRange.in_range?(range_pair, value)
      end)

    case mapping_range do
      :no_match -> value
      _ -> MappingRange.transform(mapping_range).(value)
    end
  end
end

## TODO: define `in range`, automatic conversion operation
