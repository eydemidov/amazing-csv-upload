class StrongPasswordValidator < ActiveModel::EachValidator
  PASSWORD_MIN_LENGTH = 10
  PASSWORD_MAX_LENGTH = 16

  # NOTE: only matches Basic Latin. Other alphabets could be considered.
  # see https://jrgraphix.net/research/unicode_blocks.php
  LOWER_CASE_REGEX = /[a-z]/
  UPPER_CASE_REGEX = /[A-Z]/

  PASSWORD_VIOLATIONS = {
    no_lower_case: ->(password) { password =~ LOWER_CASE_REGEX },
    no_upper_case: ->(password) { password =~ UPPER_CASE_REGEX },
    no_digits: ->(password) { password =~ /\d/ },
    repeat_chars: ->(password) { password !~ /(.)\1\1/ }
  }.freeze

  def validate_each(record, attr, val)
    validate_length(record, attr, val)
    validate_rules(record, attr, val)
  end

  private

  # Using instead of the default length validation for better encapsulation.
  def validate_length(record, attr, val)
    return if val.length.between?(PASSWORD_MIN_LENGTH, PASSWORD_MAX_LENGTH)

    record.errors.add(attr, :wrong_length, min: PASSWORD_MIN_LENGTH, max: PASSWORD_MAX_LENGTH)
  end

  def validate_rules(record, attr, val)
    PASSWORD_VIOLATIONS.each do |rule_name, rule_checker|
      record.errors.add(attr, rule_name) unless rule_checker.call(val)
    end
  end
end
