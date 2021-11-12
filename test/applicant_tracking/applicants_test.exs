defmodule ApplicantTracking.ApplicantsTest do
  use ApplicantTracking.DataCase

  alias ApplicantTracking.Applicants

  describe "applicants" do
    alias ApplicantTracking.Applicants.Applicant

    import ApplicantTracking.ApplicantsFixtures

    @invalid_attrs %{email: nil, name: nil}

    test "list_applicants/0 returns all applicants" do
      applicant = applicant_fixture()
      assert Applicants.list_applicants() == [applicant]
    end

    test "get_applicant!/1 returns the applicant with given id" do
      applicant = applicant_fixture()
      assert Applicants.get_applicant_with_comments!(applicant.id) == applicant
    end

    test "create_applicant/1 with valid data creates a applicant" do
      valid_attrs = %{email: "some@email.com", name: "some name"}

      assert {:ok, %Applicant{} = applicant} = Applicants.create_applicant(valid_attrs)
      assert applicant.email == "some@email.com"
      assert applicant.name == "some name"
    end

    test "create_applicant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Applicants.create_applicant(@invalid_attrs)
    end

    test "update_applicant/2 with valid data updates the applicant" do
      applicant = applicant_fixture()

      update_attrs = %{
        email: "someupdated@email.com",
        name: "some updated name"
      }

      assert {:ok, %Applicant{} = applicant} =
               Applicants.update_applicant(applicant, update_attrs)

      assert applicant.email == "someupdated@email.com"
      assert applicant.name == "some updated name"
    end

    test "update_applicant/2 with invalid data returns error changeset" do
      applicant = applicant_fixture()
      assert {:error, %Ecto.Changeset{}} = Applicants.update_applicant(applicant, @invalid_attrs)
      assert applicant == Applicants.get_applicant_with_comments!(applicant.id)
    end

    test "move_applicant_to_next_state/0 updates the applicant" do
      applicant = applicant_fixture()
      assert {:ok, %Applicant{} = applicant} = Applicants.move_applicant_to_next_state(applicant)
      assert applicant.state == "Interviewing"
    end

    test "change_applicant/1 returns a applicant changeset" do
      applicant = applicant_fixture()
      assert %Ecto.Changeset{} = Applicants.change_applicant(applicant)
    end
  end

  describe "comments" do
    alias ApplicantTracking.Applicants.Comment

    import ApplicantTracking.ApplicantsFixtures

    @invalid_attrs %{content: nil}

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{content: "some content"}

      assert {:ok, %Comment{} = comment} = Applicants.create_comment(valid_attrs)
      assert comment.content == "some content"
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Applicants.change_comment(comment)
    end
  end
end
