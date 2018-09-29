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

  belongs_to :site, inverse_of: :users
  has_many :articles, foreign_key: :author_id, order: :title
  has_many :comments, dependent: :destroy, autosave: true
  has_many :messages, dependent: :destroy
  has_and_belongs_to_many :children, class_name: 'User'
  has_one :record, autobuild: true, inverse_of: :user

  embeds_one :profile, inverse_of: :user

  validates :login, presence: true, uniqueness: { scope: :site }, format: { with: /\A[\w\-]+\z/ }, exclusion: { in: %w[super index edit] }
  validates :email, uniqueness: { case_sensitive: false, scope: :site, message: 'is already taken' }, confirmation: true
  validates :role, presence: true, inclusion: { in: %w[admin moderator member] }
  validates :profile, presence: true, associated: true
  validates :age, presence: true, numericality: true, inclusion: { in: 23..42 }, on: %i[create update]
  validates :password, presence: true, on: %i[create update]
  validates :password, exclusion: { in: ->(_user) { ['password'] } }
  validates :password, confirmation: { message: 'Password confirmation must match given password' }
  validates :provider_uid, presence: true
  validates :locale, inclusion: { in: ->(_user) { %i[en ru] } }

  accepts_nested_attributes_for :articles, :comments

  def admin?
    false
  end
end
