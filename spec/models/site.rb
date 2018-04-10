class Site
  include Mongoid::Document

  field :name

  if Mongoid::Compatibility::Version.mongoid6_or_older?
    has_many :users, inverse_of: :site, order: :email.desc, counter_cache: true
  else
    has_many :users, inverse_of: :site, order: :email.desc
  end

  validates :name, presence: true, uniqueness: true
end
