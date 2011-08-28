class Profile
  include Mongoid::Document
  
  field :first_name
  field :last_name
  field :age
  
  embedded_in :user, :inverse_of => :profile
  
  validates_numericality_of :age, :greater_than => 0
  
  index(
      [
        [ :first_name, Mongo::ASCENDING ],
        [ :last_name, Mongo::ASCENDING ]
      ]
  )
end