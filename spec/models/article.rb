class Article
  include Mongoid::Document
  
  field :title
  field :content
  field :published, :type => Boolean, :default => false
  
  embeds_many :comments
  referenced_in :user, :inverse_of => :articles
  
  validates :title, :presence => true
  
  validates_length_of :title, :minimum => 8, :maximum => 16
end
  