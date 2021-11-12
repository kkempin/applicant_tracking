defmodule ApplicantTracking.Applicants.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string
    belongs_to :applicant, ApplicantTracking.Applicants.Applicant

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content])
  end
end
