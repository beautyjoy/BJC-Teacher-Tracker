# frozen_string_literal: true

require "rails_helper"

RSpec.describe "layouts/_flash", type: :view do
  # Flash messages interpolate teacher- and school-supplied text (e.g.
  # "Deleted #{@teacher.full_name} successfully."), which an admin then renders.
  it "does not execute markup supplied through a teacher's name" do
    payload = "<img src=x onerror=alert(document.cookie)>"
    flash[:info] = "Deleted #{payload} Ory successfully."

    render partial: "layouts/flash"

    expect(rendered).not_to include("onerror")
    expect(rendered).to include("Ory successfully.")
  end

  it "strips script tags supplied through CSV import output" do
    flash[:alert] = "1 teachers has failed with following emails: [ <script>alert(1)</script> ]"

    render partial: "layouts/flash"

    expect(rendered).not_to include("<script>")
  end

  it "still renders the intentional link in the page login prompt" do
    flash[:info] = 'If you do not have a login, you may <a href="/teachers/new">request access</a>.'

    render partial: "layouts/flash"

    expect(rendered).to include('<a href="/teachers/new">request access</a>')
  end
end
