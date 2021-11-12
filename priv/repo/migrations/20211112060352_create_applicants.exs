defmodule ApplicantTracking.Repo.Migrations.CreateApplicants do
  use Ecto.Migration

  def change do
    create table(:applicants) do
      add :name, :string
      add :email, :string
      add :state, :string, default: "Applied"

      timestamps()
    end
  end
end
