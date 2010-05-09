class Article
  include Mongoid::Document
  
  field :title
  field :content
  field :published, :type => Boolean, :default => false
  
  embeds_many :comments
  belongs_to_related :user, :inverse_of => :articles
  
  validates :title, :presence => true
end
  