defmodule ApplicantTrackingWeb.ApplicantController do
  use ApplicantTrackingWeb, :controller

  alias ApplicantTracking.Applicants
  alias ApplicantTracking.Applicants.{Applicant, Comment}

  def index(conn, _params) do
    grouped_applicants = Applicants.list_applicants_grouped_by_state()
    render(conn, "index.html", applicants: grouped_applicants, applicant: nil)
  end

  def new(conn, _params) do
    with applicant_changeset <- Applicants.change_applicant(%Applicant{}),
         comment_changeset <- Applicants.change_comment(%Comment{}),
         applicant_with_comments <-
           Ecto.Changeset.put_assoc(applicant_changeset, :comments, [comment_changeset]) do
      render(conn, "new.html", changeset: applicant_with_comments)
    end
  end

  def create(conn, %{"applicant" => applicant_params}) do
    applicant_params = clean_applicant_params(applicant_params, applicant_params["comments"])

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
    with grouped_applicants <- Applicants.list_applicants_grouped_by_state(),
         applicant <- Applicants.get_applicant_with_comments!(id) do
      render(conn, "index.html", applicants: grouped_applicants, applicant: applicant)
    end
  end

  def edit(conn, %{"id" => id}) do
    with applicant <- Applicants.get_applicant_with_comments!(id),
         applicant_changeset <- Applicants.change_applicant(applicant),
         comment_changeset <- Applicants.change_comment(%Comment{}),
         applicant_with_comments <-
           Ecto.Changeset.put_assoc(
             applicant_changeset,
             :comments,
             applicant.comments ++ [comment_changeset]
           ) do
      render(conn, "edit.html", changeset: applicant_with_comments, applicant: applicant)
    end
  end

  def update(conn, %{"id" => id, "applicant" => applicant_params}) do
    applicant_params = clean_applicant_params(applicant_params, applicant_params["comments"])
    applicant = Applicants.get_applicant_with_comments!(id)

    case Applicants.update_applicant(applicant, applicant_params) do
      {:ok, applicant} ->
        conn
        |> put_flash(:info, "Applicant updated successfully.")
        |> redirect(to: Routes.applicant_path(conn, :show, applicant))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        render(conn, "edit.html", applicant: applicant, changeset: changeset)
    end
  end

  def move_to_next_state(conn, %{"id" => id}) do
    with applicant <- Applicants.get_applicant!(id),
         {:ok, applicant} <- Applicants.move_applicant_to_next_state(applicant) do
      applicant.email
      |> ApplicantTracking.UserEmail.state_changed(applicant.name, applicant.state)
      |> ApplicantTracking.Mailer.deliver()

      conn
      |> put_flash(:info, "Applicant successfully moved to state #{applicant.state}.")
      |> redirect(to: Routes.applicant_path(conn, :index))
    end
  end

  defp clean_applicant_params(applicant_params, nil), do: applicant_params

  defp clean_applicant_params(applicant_params, comments) when is_map(comments) do
    comments =
      comments
      |> Enum.filter(fn {_k, comment} ->
        comment["id"] || String.trim(comment["content"]) != ""
      end)
      |> Enum.into(%{})

    Map.put(applicant_params, "comments", comments) |> IO.inspect()
  end
end
