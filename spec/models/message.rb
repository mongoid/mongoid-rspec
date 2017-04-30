class Message
  include Mongoid::Document

  field :identifier
  field :from
  field :to

  validates :identifier, uniqueness: { message: 'uniqueness' }
  validates :from, presence: { message: 'required' }
  validates :to, format: { with: /[a-z]+/, message: 'format' }
end
