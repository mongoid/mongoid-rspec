RSpec::Matchers.define :be_stored_in do |collection_name|
  match do |doc|
    doc.class.collection_name == collection_name
  end

  description do
    "be stored in #{collection_name.to_s}"
  end
end