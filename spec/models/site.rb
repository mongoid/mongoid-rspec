class Site
  include Mongoid::Document

  field :name

  has_many :users, inverse_of: :site, order: :email.desc, counter_cache: true

  validates :name, presence: true, uniqueness: true
end
