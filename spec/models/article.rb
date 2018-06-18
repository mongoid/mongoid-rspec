class Article
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, localize: true
  field :content
  field :published, type: Boolean, default: false
  field :allow_comments, type: Boolean, default: true
  field :number_of_comments, type: Integer
  field :status, type: Symbol
  field :deletion_date, type: DateTime, default: nil

  embeds_many :comments, cascade_callbacks: true, inverse_of: :article
  embeds_one :permalink, inverse_of: :linkable
  belongs_to :author, class_name: 'User', inverse_of: :articles, index: true

  validates :title, presence: true

  validates_inclusion_of :status, in: [:pending], on: :create
  validates_inclusion_of :status, in: %i[approved rejected], on: :update

  validates_length_of :title, within: 8..16
  validates_length_of :content, minimum: 200

  validates_absence_of :deletion_date if Mongoid::Compatibility::Version.mongoid4_or_newer?

  index({ title: 1 }, unique: true, background: true, drop_dups: true)
  index(published: 1)
  index('permalink._id' => 1)

  accepts_nested_attributes_for :permalink
end
