class SsnValidator <  ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    record.errors[attribute] << "#{value} is not a valid Social Security Number" unless valid_ssn?(record, attribute, value)
  end

  def self.kind() :custom end

  def valid_ssn?(record, attribute, value)
    # irrelevant here how validation is done
    true
  end

end