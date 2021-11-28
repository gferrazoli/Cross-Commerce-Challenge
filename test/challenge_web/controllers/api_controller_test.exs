defmodule ChallengeWeb.ApiControllerTest do
  use ChallengeWeb.ConnCase
  use Mimic
  alias Challenge.Requests.Request.Mock

  setup :set_mimic_global

  test "GET [] /api/result", %{conn: conn} do
    Mock.mock_request(
      &stub/3,
      %{
        "numbers" => []
      }
    )

    conn = get(conn, "/api/result")

    assert %{"result" => []} == json_response(conn, 200)
  end

  test "GET 404 /api/result", %{conn: conn} do
    Mock.mock_request(
      &stub/3,
      {:error, "Challenge API unreachable"}
    )

    conn = get(conn, "/api/result")

    assert %{"result" => "Challenge API unreachable"} == json_response(conn, 200)
  end
end
