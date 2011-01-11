class User
  include Mongoid::Document

  field :login
  field :email
  field :role

  referenced_in :site, :inverse_of => :users
  references_one :article
  references_many :comments
  references_and_referenced_in_many :children, :class_name => "User"

  embeds_one :profile

  validates :login, :presence => true, :uniqueness => { :scope => :site }, :format => { :with => /^[\w\-]+$/ }
  validates :email, :uniqueness => { :case_sensitive => false, :scope => :site, :message => "is already taken" }
  validates :role, :presence => true, :inclusion => { :in => ["admin", "moderator", "member"]}
  validates :profile, :presence => true, :associated => true

  def admin?
    false
  end
end
