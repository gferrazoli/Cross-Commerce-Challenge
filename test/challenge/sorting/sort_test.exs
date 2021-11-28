defmodule Challenge.Sorting.SortTest do
  use Challenge.DataCase
  alias Challenge.Sorting.Sort

  test "merge sort" do
    sorted_numbers =
      Sort.merge_sort([5, 23, 521, 12, 1252, 1, 2, 4, 0.32534, 123, 653, 685, 7564, 1425, 6, 3])

    assert [0.32534, 1, 2, 3, 4, 5, 6, 12, 23, 123, 521, 653, 685, 1252, 1425, 7564] ==
             sorted_numbers
  end
end
