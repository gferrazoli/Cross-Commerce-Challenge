defmodule Challenge.Sorting.Sort do
  def merge_sort({:error, reason}), do: reason

  def merge_sort([]), do: []
  def merge_sort([_] = list), do: list

  def merge_sort(list) when is_list(list) do
    len = length(list)
    {a, b} = Enum.split(list, div(len, 2))
    a = merge_sort(a)
    b = merge_sort(b)
    merge(a, b, [])
  end

  defp merge([], b, acc), do: Enum.reverse(acc) ++ b
  defp merge(a, [], acc), do: Enum.reverse(acc) ++ a

  defp merge([a_head | a_tail] = _a, [b_head | _b_tail] = b, acc) when a_head <= b_head,
    do: merge(a_tail, b, [a_head | acc])

  defp merge([_a_head | _a_tail] = a, [b_head | b_tail] = _b, acc),
    do: merge(a, b_tail, [b_head | acc])
end
