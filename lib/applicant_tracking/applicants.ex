defmodule ApplicantTracking.Applicants do
  @moduledoc """
  The Applicants context.
  """

  import Ecto.Query, warn: false
  alias ApplicantTracking.Repo

  alias ApplicantTracking.Applicants.{Applicant, Comment}

  @doc """
  Returns the list of applicants.

  ## Examples

      iex> list_applicants()
      [%Applicant{}, ...]

  """
  def list_applicants() do
    Applicant
    |> Repo.all()
    |> Repo.preload(:comments)
  end

  @doc """
  Returns the list of applicants grouped by state.

  ## Examples

      iex> list_applicants_grouped_by_state()
      %{"state" => [%Applicant{}], ...}

  """
  def list_applicants_grouped_by_state() do
    applicants = Enum.group_by(list_applicants(), & &1.state)

    Applicant.allowed_states()
    |> Enum.map(fn state ->
      if applicants[state] do
        {state, applicants[state]}
      end
    end)
  end

  @doc """
  Gets a single applicant.

  Raises `Ecto.NoResultsError` if the Applicant does not exist.

  ## Examples

      iex> get_applicant!(123)
      %Applicant{}

      iex> get_applicant!(456)
      ** (Ecto.NoResultsError)

  """
  def get_applicant!(id), do: Repo.get!(Applicant, id)

  @doc """
  Gets a single applicant with comments preloaded.

  Raises `Ecto.NoResultsError` if the Applicant does not exist.

  ## Examples

      iex> get_applicant_with_comments!(123)
      %Applicant{}

      iex> get_applicant_with_comments!(456)
      ** (Ecto.NoResultsError)

  """
  def get_applicant_with_comments!(id), do: Repo.get!(Applicant, id) |> Repo.preload(:comments)

  @doc """
  Creates a applicant.

  ## Examples

      iex> create_applicant(%{field: value})
      {:ok, %Applicant{}}

      iex> create_applicant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_applicant(attrs \\ %{}) do
    %Applicant{}
    |> Applicant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a applicant.

  ## Examples

      iex> update_applicant(applicant, %{field: new_value})
      {:ok, %Applicant{}}

      iex> update_applicant(applicant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_applicant(%Applicant{} = applicant, attrs) do
    applicant
    |> Applicant.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Move an applicant to the next state.

  ## Examples

      iex> move_applicant_to_next_state(applicant)
      {:ok, %Applicant{}}

      iex> move_applicant_to_next_state(applicant)
      {:error, %Ecto.Changeset{}}

  """
  def move_applicant_to_next_state(%Applicant{} = applicant) do
    allowed_states = Applicant.allowed_states()
    current_state_index = Enum.find_index(allowed_states, &(&1 == applicant.state))
    next_state = Enum.at(allowed_states, current_state_index + 1, applicant.state)

    applicant
    |> Applicant.state_update_changeset(%{state: next_state})
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking applicant changes.

  ## Examples

      iex> change_applicant(applicant)
      %Ecto.Changeset{data: %Applicant{}}

  """
  def change_applicant(%Applicant{} = applicant, attrs \\ %{}) do
    Applicant.changeset(applicant, attrs)
  end

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end
end
