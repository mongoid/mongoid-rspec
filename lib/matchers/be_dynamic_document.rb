RSpec::Matchers.define :be_dynamic_document do |_|
  match do |doc|
    doc.class.included_modules.include?(Mongoid::Attributes::Dynamic)
  end

  description do
    'be a Mongoid document with dynamic attributes'
  end
end
