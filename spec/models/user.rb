class User
  include Mongoid::Document
  
  field :login
  field :email
  field :role
  
  references_many :articles
  references_many :comments
  references_many :children, :stored_as => :array, :class_name => "User"
  
  embeds_one :profile
  
  validates :login, :presence => true, :uniqueness => true, :format => { :with => /^[\w\-]+$/ }
  validates_uniqueness_of :email, :case_sensitive => false
  validates :role, :presence => true, :inclusion => { :in => ["admin", "moderator", "member"]}  
  validates :profile, :presence => true, :associated => true
  
  def admin?
    false
  end
end