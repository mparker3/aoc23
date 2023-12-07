defmodule Day7Test do
  use ExUnit.Case
  doctest Day7

  test "matches_hands" do
    assert Day7.get_hand_type("AAAAA") == :five
    assert Day7.get_hand_type("AAAAK") == :four
    assert Day7.get_hand_type("KK111") == :full_house
    assert Day7.get_hand_type("KAAA8") == :three
    assert Day7.get_hand_type("88722") == :two_pair
    assert Day7.get_hand_type("85477") == :one_pair
    assert Day7.get_hand_type("AKQJT") == :high
  end

  test "part_two_matches_hands" do
    assert PartTwo.get_hand_type("JJJJJ") == :five
    assert PartTwo.get_hand_type("JJJJ2") == :five
    assert PartTwo.get_hand_type("KK111") == :full_house
    assert PartTwo.get_hand_type("KAAA8") == :three
    assert PartTwo.get_hand_type("88722") == :two_pair
    assert PartTwo.get_hand_type("85477") == :one_pair
    assert PartTwo.get_hand_type("AKQJT") == :high
  end
end
