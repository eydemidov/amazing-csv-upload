require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    subject(:user) { build(:user, name: "Blah") }

    context "when name is nil" do
      before { user.name = nil }
      it { should_not be_valid }
    end

    context "when name is blank" do
      before { user.name = " " }
      it { should_not be_valid }
    end

    context "when name already exists, case-insensitive" do
      before do
        create(:user, name: "Gregorz")
        user.name = "GReGoRZ"
      end

      it { should_not be_valid }
    end
  end
end
