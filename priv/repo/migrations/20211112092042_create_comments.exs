defmodule ApplicantTracking.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :string
      add :applicant_id, references(:applicants, on_delete: :delete_all)

      timestamps()
    end

    create index(:comments, [:applicant_id])
  end
end
