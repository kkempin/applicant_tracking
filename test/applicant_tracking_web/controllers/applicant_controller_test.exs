defmodule ApplicantTrackingWeb.ApplicantControllerTest do
  use ApplicantTrackingWeb.ConnCase

  alias ApplicantTracking.Applicants

  @create_attrs %{email: "some@email.com", name: "some name"}
  @update_attrs %{
    email: "some_updated@email.com",
    name: "some updated name"
  }
  @invalid_attrs %{email: nil, name: nil}

  def fixture(:applicant) do
    {:ok, applicant} = Applicants.create_applicant(@create_attrs)
    applicant
  end

  describe "index" do
    test "lists all applicants", %{conn: conn} do
      Applicants.create_applicant(@create_attrs)
      conn = get(conn, Routes.applicant_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Applicants"
    end
  end

  describe "new applicant" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.applicant_path(conn, :new))
      assert html_response(conn, 200) =~ "New Applicant"
    end
  end

  describe "create applicant" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.applicant_path(conn, :create), applicant: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.applicant_path(conn, :show, id)

      conn = get(conn, Routes.applicant_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Applicant"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.applicant_path(conn, :create), applicant: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Applicant"
    end
  end

  describe "edit applicant" do
    setup [:create_applicant]

    test "renders form for editing chosen applicant", %{conn: conn, applicant: applicant} do
      conn = get(conn, Routes.applicant_path(conn, :edit, applicant))
      assert html_response(conn, 200) =~ "Edit Applicant"
    end
  end

  describe "update applicant" do
    setup [:create_applicant]

    test "redirects when data is valid", %{conn: conn, applicant: applicant} do
      conn = put(conn, Routes.applicant_path(conn, :update, applicant), applicant: @update_attrs)
      assert redirected_to(conn) == Routes.applicant_path(conn, :show, applicant)

      conn = get(conn, Routes.applicant_path(conn, :show, applicant))
      assert html_response(conn, 200) =~ "some_updated@email.com"
    end

    test "renders errors when data is invalid", %{conn: conn, applicant: applicant} do
      conn = put(conn, Routes.applicant_path(conn, :update, applicant), applicant: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Applicant"
    end
  end

  describe "move applicant to next stage" do
    setup [:create_applicant]

    test "moves chosen applicant to next stage", %{conn: conn, applicant: applicant} do
      conn = get(conn, Routes.applicant_path(conn, :move_to_next_state, applicant))
      applicant = Applicants.get_applicant!(applicant.id)

      assert redirected_to(conn) == Routes.applicant_path(conn, :index)
      assert applicant.state == "Interviewing"
    end
  end

  defp create_applicant(_) do
    applicant = fixture(:applicant)
    %{applicant: applicant}
  end
end
