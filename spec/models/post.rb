class Post
  include Mongoid::Document

  field :name
  field :date

  belongs_to :user

  validates :name, presence: true, uniqueness: true
end
