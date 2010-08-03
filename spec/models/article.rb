class Article
  include Mongoid::Document
  
  field :title
  field :content
  field :published, :type => Boolean, :default => false
  
  embeds_many :comments
  referenced_in :user, :inverse_of => :articles
  
  validates :title, :presence => true
end
  