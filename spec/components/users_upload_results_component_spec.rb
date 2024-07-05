require "rails_helper"

RSpec.describe UsersUploadResultsComponent, type: :component do
  include ViewComponent::TestHelpers

  let(:results) do
    [
      { name: "Bobr", success: true },
      { name: "Kurwa", success: false, errors: ["some error", "another error"] }
    ]
  end

  subject { render_inline(UsersUploadResultsComponent.new(results:)).to_html }

  it "renders the upload results header" do
    expect(subject).to include(I18n.t("users_uploads.upload_results"))
  end

  it "renders the table headers" do
    expect(subject).to include(I18n.t("users_uploads.user_name"))
    expect(subject).to include(I18n.t("users_uploads.results"))
  end

  it "displays the results" do
    expect(subject).to include("Bobr")
    expect(subject).to include(I18n.t("users_uploads.created"))
    expect(subject).to include("Kurwa")
    expect(subject).to include(I18n.t("users_uploads.rejected"))
    expect(subject).to include("some error")
    expect(subject).to include("another error")
  end
end
