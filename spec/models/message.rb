class Message
  include Mongoid::Document

  field :identifier
  field :from
  field :to

  if Mongoid::Compatibility::Version.mongoid6_or_newer?
    belongs_to :user, optional: true
  else
    belongs_to :user
  end

  validates :identifier, uniqueness: { message: 'uniqueness' }
  validates :from, presence: { message: 'required' }
  validates :to, format: { with: /[a-z]+/, message: 'format' }
end
