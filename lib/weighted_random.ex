defmodule WeightedRandom do
  @doc """
    ## Examples

    iex> WeightedRandom.between(0, 100)
    23
  """
  def between(min, max) do Enum.random(min..max) end

  @doc """
    ## Examples

    iex> WeightedRandom.numList(0, 100, 10)
    [87, 19, 8, 20, 11, 37, 85, 88, 69, 47, 39]
  """
  def numList(min, max, length) do
    Enum.reduce(0..length, [], fn(_, acc) -> [between(min, max) | acc] end)
  end

  @doc """
    Gets a random number between min and max.
    If the weight is 1, then it's purely random.
    If the weight is higher, then the number will be closer to the target

    ## Examples

    iex> WeightedRandom.weighted(0, 100, 75, 10)
    83
  """
  def weighted(min, max, target, weight) do
    range = numList(min, max, weight)

    Enum.reduce(range, min, fn(curr, acc) ->
      new = abs(target - curr)
      old = abs(target - acc)
      closer = new < old
      case closer do
        true -> curr
        false -> acc
      end end)
  end

  @doc """
    Takes a different weight for each value, and randomly returns a value.
    If each map has the same weight, they will all be equally likely to be returned.
    A map with a relatively higher weight will be more likely to be returned.
    ## Examples

    iex> maplist = [ %{:value => :red, :weight => 15}, %{:value => :blue, :weight => 1}, %{:value => :yellow, :weight => 5} ]
    iex> WeightedRandom.complex(maplist)
    :red
  """
  def complex(maplist) do
      result = Enum.reduce(maplist, %{:roll => 0, :value => nil}, fn(%{:value => value, :weight => weight}, acc) ->
          roll = weighted(0, 100, 100, weight)
          closer = roll > acc.roll
          case closer do
              true -> %{:roll => roll, :value => value}
              false -> acc
          end
      end)
      result.value
  end

end