class User
  include Mongoid::Document

  field :login
  field :email
  field :role
  field :age, type: Integer
  field :password, type: String

  referenced_in :site, :inverse_of => :users
  references_many :articles, :foreign_key => :author_id
  references_many :comments, :dependent => :destroy, :autosave => true
  references_and_referenced_in_many :children, :class_name => "User"
  references_one :record

  embeds_one :profile

  validates :login, :presence => true, :uniqueness => { :scope => :site }, :format => { :with => /^[\w\-]+$/ }, :exclusion => { :in => ["super", "index", "edit"]}
  validates :email, :uniqueness => { :case_sensitive => false, :scope => :site, :message => "is already taken" }, :confirmation => true
  validates :role, :presence => true, :inclusion => { :in => ["admin", "moderator", "member"]}  
  validates :profile, :presence => true, :associated => true
  validates :age, :presence => true, :numericality => true, :inclusion => { :in => 23..42 }, :on => [:create, :update]
  validates :password, :presence => true, :on => :create

  def admin?
    false
  end
end
