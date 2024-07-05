require "rails_helper"

RSpec.describe UsersUploadForm, type: :model do
  let(:csv_path) { Rails.root.join("spec/fixtures/users.csv") }

  let(:file) { fixture_file_upload(csv_path, "text/csv") }

  describe "#save" do
    context "when the file is valid" do
      it "processes the CSV file and creates users" do
        form = UsersUploadForm.new(file:)
        expect { form.save }.to change { User.count }.by(1)
        expect(form.results.size).to eq(4)
      end
    end

    context "when the file doesn't exist" do
      it "doesn't create users and returns false" do
        form = UsersUploadForm.new(file: nil)
        expect(form.save).to be_falsey
        expect(form.results).to be_nil
      end
    end
  end
end
