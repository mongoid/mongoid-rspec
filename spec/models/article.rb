class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Versioning
  include Mongoid::MultiParameterAttributes

  field :title
  field :content
  field :published, :type => Boolean, :default => false
  field :allow_comments, :type => Boolean, :default => true

  embeds_many :comments
  embeds_one :permalink
  belongs_to :author, :class_name => 'User', :inverse_of => :articles, :index => true

  validates :title, :presence => true

  validates_length_of :title, :minimum => 8, :maximum => 16

  index({ title: 1 }, { unique: true, background: true })
  index({ published: 1 })
end