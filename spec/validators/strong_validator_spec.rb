require "rails_helper"

RSpec.describe StrongPasswordValidator do
  subject(:validator) { StrongPasswordValidator.new(attributes: :password) }

  let(:record) { build(:user) }

  describe "#validate_each" do
    it "calls validate_length and validate_rules" do
      expect(validator).to receive(:validate_length).with(record, :password, "")
      expect(validator).to receive(:validate_rules).with(record, :password, "")

      validator.validate_each(record, :password, "")
    end
  end

  describe "#validate_length" do
    it "adds an error if password is too short" do
      validator.__send__(:validate_length, record, :password, "123456789")
      expect(record.errors[:password]).to(
        include(
          I18n.t("activerecord.errors.models.user.attributes.password.wrong_length",
                 min: StrongPasswordValidator::PASSWORD_MIN_LENGTH,
                 max: StrongPasswordValidator::PASSWORD_MAX_LENGTH)
        )
      )
    end

    it "adds an error if password is too long" do
      validator.__send__(:validate_length, record, :password, "123456789asffwefwfwefwfewfw343242")
      expect(record.errors[:password]).to(
        include(
          I18n.t("activerecord.errors.models.user.attributes.password.wrong_length",
                 min: StrongPasswordValidator::PASSWORD_MIN_LENGTH,
                 max: StrongPasswordValidator::PASSWORD_MAX_LENGTH)
        )
      )
    end

    it "does not add an error if password length is valid" do
      validator.__send__(:validate_length, record, :password, "valid_password_1")
      expect(record.errors[:password]).to be_empty
    end
  end

  describe "#validate_rules" do
    it "adds an error if password does not contain a lower case char" do
      validator.__send__(:validate_rules, record, :password, "PASSWORD13414")
      expect(record.errors[:password]).to include(I18n.t("activerecord.errors.models.user.attributes.password.no_lower_case"))
    end

    it "adds an error if password does not contain an upper case char" do
      validator.__send__(:validate_rules, record, :password, "smol1234342")
      expect(record.errors[:password]).to include(I18n.t("activerecord.errors.models.user.attributes.password.no_upper_case"))
    end

    it "adds an error if password does not contain any numbers" do
      validator.__send__(:validate_rules, record, :password, "no_numberSszzdf")
      expect(record.errors[:password]).to include(I18n.t("activerecord.errors.models.user.attributes.password.no_digits"))
    end

    it "adds an error if password contains repeated characters" do
      validator.__send__(:validate_rules, record, :password, "sss_dsfsdV123")
      expect(record.errors[:password]).to include(I18n.t("activerecord.errors.models.user.attributes.password.repeat_chars"))
    end

    it "does not add an error if password fulfils all the rules" do
      validator.__send__(:validate_rules, record, :password, "Valid_password_1")
      expect(record.errors[:password]).to be_empty
    end
  end
end
