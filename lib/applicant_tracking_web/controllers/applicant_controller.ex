defmodule ApplicantTrackingWeb.ApplicantController do
  use ApplicantTrackingWeb, :controller

  alias ApplicantTracking.Applicants
  alias ApplicantTracking.Applicants.Applicant

  def index(conn, _params) do
    grouped_applicants = Applicants.list_applicants_grouped_by_state()
    render(conn, "index.html", applicants: grouped_applicants)
  end

  def new(conn, _params) do
    changeset = Applicants.change_applicant(%Applicant{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"applicant" => applicant_params}) do
    case Applicants.create_applicant(applicant_params) do
      {:ok, applicant} ->
        conn
        |> put_flash(:info, "Applicant created successfully.")
        |> redirect(to: Routes.applicant_path(conn, :show, applicant))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    applicant = Applicants.get_applicant!(id)
    render(conn, "show.html", applicant: applicant)
  end

  def edit(conn, %{"id" => id}) do
    applicant = Applicants.get_applicant!(id)
    changeset = Applicants.change_applicant(applicant)
    render(conn, "edit.html", applicant: applicant, changeset: changeset)
  end

  def update(conn, %{"id" => id, "applicant" => applicant_params}) do
    applicant = Applicants.get_applicant!(id)

    case Applicants.update_applicant(applicant, applicant_params) do
      {:ok, applicant} ->
        conn
        |> put_flash(:info, "Applicant updated successfully.")
        |> redirect(to: Routes.applicant_path(conn, :show, applicant))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", applicant: applicant, changeset: changeset)
    end
  end

  def move_to_next_state(conn, %{"id" => id}) do
    with applicant <- Applicants.get_applicant!(id),
         {:ok, applicant} <- Applicants.move_applicant_to_next_state(applicant) do
      conn
      |> put_flash(:info, "Applicant successfully moved to state #{applicant.state}.")
      |> redirect(to: Routes.applicant_path(conn, :index))
    end
  end
end
