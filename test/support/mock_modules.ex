defmodule Challenge.Requests.Request.Mock do
  def request_numbers_from_challenge(_), do: raise("Mock not defined")

  def mock_request(stub_fn, return_value) do
    stub_fn.(__MODULE__, :request_numbers_from_challenge, fn _ -> return_value end)
  end
end
