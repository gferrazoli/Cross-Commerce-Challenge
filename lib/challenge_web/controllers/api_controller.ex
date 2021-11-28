defmodule ChallengeWeb.ApiController do
  use ChallengeWeb, :controller
  alias Challenge.Extraction.Extract
  alias Challenge.Sorting.Sort

  def get_results(conn, _params) do
    sorted_numbers = extract_and_sort()

    json(conn, %{result: sorted_numbers})
  end

  defp extract_and_sort() do
    Extract.extract_from_api()
    |> Sort.merge_sort()
  end
end
