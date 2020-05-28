defmodule CurryTime.Repo do
  use Ecto.Repo,
    otp_app: :curry_time,
    adapter: Ecto.Adapters.Postgres
end
