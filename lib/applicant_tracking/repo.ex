defmodule ApplicantTracking.Repo do
  use Ecto.Repo,
    otp_app: :applicant_tracking,
    adapter: Ecto.Adapters.Postgres
end
