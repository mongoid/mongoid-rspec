class Site
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Versioning
  
  field :name
  
  references_many :users, :inverse_of => :site
  
  validates :name, :presence => true, :uniqueness => true
  
end