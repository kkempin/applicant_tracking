defmodule ApplicantTracking.UserEmail do
  import Swoosh.Email

  @spec state_changed(String.t(), String.t(), String.t()) :: Swoosh.Email.t()
  def state_changed(email, name, status) do
    new()
    |> to({name, email})
    |> from({"Applicants tracking", "applicants@example.com"})
    |> subject("Status changed!")
    |> html_body("<h1>Hello #{name}</h1>Your status changed to #{status}")
    |> text_body("Hello #{name}\nYour status changed to #{status}")
  end
end
