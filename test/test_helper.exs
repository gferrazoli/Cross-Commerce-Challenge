ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Challenge.Repo, :manual)

Enum.each(
  [
    Challenge.Requests.Request.Mock
  ],
  &Mimic.copy/1
)
