require "rails_helper"

RSpec.feature "UsersUpload", type: :feature, js: true do
  scenario "User uploads a CSV file and sees the results" do
    csv_path = Rails.root.join("spec/fixtures/users.csv")

    visit new_users_upload_path

    attach_file "users_upload[file]", csv_path
    click_button I18n.t("users_uploads.upload")

    within("#results-container") do
      within("tr", text: "Muhammad") do
        expect(page).to have_content(I18n.t("users_uploads.created"))
      end

      within("tr", text: "Isabella") do
        expect(page).to have_content(I18n.t("users_uploads.rejected"))
      end
    end

    expect(page).to_not have_content(I18n.t("users_uploads.upload_failed"))
  end

  scenario "User doesn't upload a file and sees an error" do
    visit new_users_upload_path

    click_button I18n.t("users_uploads.upload")

    expect(page).to have_content(I18n.t("users_uploads.upload_failed"))
  end
end
