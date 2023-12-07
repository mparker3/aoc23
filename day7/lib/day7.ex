defmodule Day7 do
  @card_ordering String.graphemes("AKQJT98765432")
  def card_ordering do
    @card_ordering
  end

  @hand_ordering [:five, :four, :full_house, :three, :two_pair, :one_pair, :high]
  def hand_ordering do
    @hand_ordering
  end

  def get_hand_type(hand) do
    # get the frequency of each card
    frequencies =
      hand
      |> String.graphemes()
      |> Enum.frequencies()
      |> Enum.reduce(%{}, fn {_, v}, acc ->
        Map.update(acc, v, 1, &(&1 + 1))
      end)

    case frequencies do
      %{5 => _} -> :five
      %{4 => _, 1 => _} -> :four
      %{2 => 1, 3 => 1} -> :full_house
      %{3 => _, 1 => _} -> :three
      %{2 => 2, 1 => _} -> :two_pair
      %{2 => _, 1 => _} -> :one_pair
      _ -> :high
    end
  end

  def compare(hand_one, hand_two) do
    hand_one_type = get_hand_type(hand_one)
    hand_two_type = get_hand_type(hand_two)

    hand_one_index = Enum.find_index(hand_ordering(), &(&1 == hand_one_type))
    hand_two_index = Enum.find_index(hand_ordering(), &(&1 == hand_two_type))

    cond do
      hand_one_index < hand_two_index ->
        :player_one

      hand_one_index > hand_two_index ->
        :player_two

      true ->
        fallback_compare(hand_one, hand_two)
    end
  end

  def fallback_compare(hand_one, hand_two) do
    # zip the cards together in order
    comparisons =
      Enum.map([hand_one, hand_two], &String.graphemes/1)
      |> Enum.zip()

    # compare the cards in order
    Enum.reduce(comparisons, :tie, fn {card_one, card_two}, acc ->
      if acc == :tie do
        compare_cards(card_one, card_two)
      else
        acc
      end
    end)
  end

  def compare_cards(card_one, card_two) do
    card_one_index = Enum.find_index(card_ordering(), &(&1 == card_one))
    card_two_index = Enum.find_index(card_ordering(), &(&1 == card_two))

    cond do
      card_one_index < card_two_index ->
        :player_one

      card_one_index > card_two_index ->
        :player_two

      true ->
        :tie
    end
  end

  def part_one do
    # stream lines from input
    File.stream!("input.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.sort(fn line_one, line_two ->
      # split the lines into hands
      [hand_one, _] = line_one
      [hand_two, _] = line_two

      # compare the hands
      winner = compare(hand_one, hand_two)

      case winner do
        :player_one ->
          false

        :player_two ->
          true

        :tie ->
          raise "tie"
      end
    end)

    # zip into pairs with the index
    |> Enum.with_index()
    |> Enum.map(fn {[_, bid], index} ->
      String.to_integer(bid) * (index + 1)
    end)
    |> Enum.sum()
  end
end
