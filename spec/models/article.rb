class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Versioning
  
  field :title
  field :content
  field :published, :type => Boolean, :default => false
  field :allow_comments, :type => Boolean, :default => true
  
  embeds_many :comments
  embeds_one :permalink
  referenced_in :author, :class_name => 'User', :inverse_of => :articles, :index => true
  
  validates :title, :presence => true
  
  validates_length_of :title, :minimum => 8, :maximum => 16
  
  index :title, :unique => true, :background => true
  index :published
end
  