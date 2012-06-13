class Profile
  include Mongoid::Document
  
  field :first_name
  field :last_name
  field :age
  
  embedded_in :user, :inverse_of => :profile
  
  validates_numericality_of :age, :greater_than => 0
  validates_acceptance_of :terms_of_service

  index({first_name: 1, last_name: 1 })
end
