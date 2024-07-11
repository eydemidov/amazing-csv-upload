require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    subject(:user) { build(:user, name: "Blah") }

    context "name validations" do
      context "when name is valid" do
        it "doesn't add an error" do
          expect(user).to be_valid
          expect(user.errors[:name]).to_not include(I18n.t("errors.messages.blank"))
        end
      end

      context "when name is nil" do
        before { user.name = nil }

        it "adds an error" do
          expect(user).not_to be_valid
          expect(user.errors[:name]).to include(I18n.t("errors.messages.blank"))
        end
      end

      context "when name is blank" do
        before { user.name = " " }

        it "adds an error" do
          expect(user).not_to be_valid
          expect(user.errors[:name]).to include(I18n.t("errors.messages.blank"))
        end
      end

      context "when name already exists, case-insensitive" do
        before do
          create(:user, name: "Gregorz")
          user.name = "GReGoRZ"
        end

        it "adds an error" do
          expect(user).not_to be_valid
          expect(user.errors[:name]).to include(I18n.t("errors.messages.taken"))
        end
      end
    end

    context "password validations" do
      context "when name is nil" do
        before { user.password = nil }

        it "adds an error" do
          expect(user).not_to be_valid
          expect(user.errors[:password]).to include(I18n.t("errors.messages.blank"))
        end
      end

      it "should include StrongPasswordValidator" do
        expect(User.validators_on(:password).map(&:class)).to include(StrongPasswordValidator)
      end
    end
  end
end
