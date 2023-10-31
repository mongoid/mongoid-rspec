# frozen_string_literal: true

class SsnValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless valid_ssn?(record, attribute, value)
      record.errors[attribute] << "#{value} is not a valid Social Security Number"
    end
  end

  def self.kind
    :custom
  end

  def valid_ssn?(_record, _attribute, _value)
    # irrelevant here how validation is done
    true
  end
end
