RSpec::Matchers.define :be_stored_in do |collection_name|
  match do |doc|
    doc.collection_name == collection_name.to_s
  end

  description do
    "be stored in #{collection_name.to_s}"
  end
end