defmodule Challenge.Requests.Request do
  require Logger
  @url "http://challenge.dienekes.com.br/api/numbers?page="

  def request_numbers_from_challenge(page) do
    page
    |> mount_url()
    |> do_request()
  end

  def do_request(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode!(body)

      {:ok, %HTTPoison.Response{status_code: 500, body: _body}} ->
        Logger.warn("Possible fake error status code 500")
        {:error, "Bad Request"}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.error("Not Found")
        {:error, "Challenge API unreachable"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("#{reason}")
        {:error, "Challenge API unreachable"}
    end
  end

  defp mount_url(page) do
    @url <> "#{page}"
  end
end
