defmodule ApplicantTracking.Applicants.Applicant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "applicants" do
    field :email, :string
    field :name, :string
    field :state, :string, default: "Applied"

    timestamps()
  end

  @allowed_states ~w(Applied Interviewing Hired Passed)

  @doc false
  def changeset(applicant, attrs) do
    applicant
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> validate_format(:email, email_regexp())
  end

  @doc false
  def state_update_changeset(applicant, attrs) do
    applicant
    |> cast(attrs, [:state])
    |> validate_required([:state])
    |> validate_inclusion(:state, @allowed_states)
  end

  def allowed_states(), do: @allowed_states

  defp email_regexp() do
    expr =
      "^[\\w!#$%&'*+/=?`{|}~^-]+" <>
        "(?:\\.[\\w!#$%&'*+/=?`{|}~^-]+)*@(?:[A-Z0-9-]+\\.)+[A-Z]{2,}(\\?.*)?$"

    Regex.compile!(expr, "i")
  end
end
