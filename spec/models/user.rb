class User
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :login
  field :email
  field :role
  field :age, type: Integer
  field :password, type: String
  field :provider_uid
  field :locale

  belongs_to :site, :inverse_of => :users
  has_many :articles, :foreign_key => :author_id
  has_many :comments, :dependent => :destroy, :autosave => true
  has_and_belongs_to_many :children, :class_name => "User"
  has_one :record, :autobuild => true

  embeds_one :profile

  validates :login, :presence => true, :uniqueness => { :scope => :site }, :format => { :with => /^[\w\-]+$/ }, :exclusion => { :in => ["super", "index", "edit"]}
  validates :email, :uniqueness => { :case_sensitive => false, :scope => :site, :message => "is already taken" }, :confirmation => true
  validates :role, :presence => true, :inclusion => { :in => ["admin", "moderator", "member"]}
  validates :profile, :presence => true, :associated => true
  validates :age, :presence => true, :numericality => true, :inclusion => { :in => 23..42 }, :on => [:create, :update]
  validates :password, :presence => true, :on => [:create, :update]
  validates :provider_uid, presence: true
  validates :locale, :inclusion => {:in => lambda { |user| [:en, :ru] } }

  attr_accessible :login, :email, :age, :password
  attr_accessible :role, :as => :admin

  accepts_nested_attributes_for :articles, :comments

  def admin?
    false
  end
end
