defmodule ApplicantTracking.ApplicantsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ApplicantTracking.Applicants` context.
  """

  @doc """
  Generate a applicant.
  """
  def applicant_fixture(attrs \\ %{}) do
    {:ok, applicant} =
      attrs
      |> Enum.into(%{
        email: "some@email.com",
        name: "some name"
      })
      |> ApplicantTracking.Applicants.create_applicant()

    applicant
  end

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> ApplicantTracking.Applicants.create_comment()

    comment
  end
end
