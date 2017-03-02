RSpec::Matchers.define :be_mongoid_document do
  match do |doc|
    doc.class.included_modules.include?(Mongoid::Document)
  end

  description do
    "be a Mongoid document"
  end
end
