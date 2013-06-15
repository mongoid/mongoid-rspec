class Profile
  include Mongoid::Document

  field :first_name
  field :last_name
  field :age
  field :hobbies, type: Array, default: []

  embedded_in :user, inverse_of: :profile

  validates :age, numericality: { greater_than: 0 }
  validates :terms_of_service, acceptance: true
  validates :hobbies, length: { minimum: 1, message: "requires at least one hobby" }

  index({ first_name: 1, last_name: 1 })
end
