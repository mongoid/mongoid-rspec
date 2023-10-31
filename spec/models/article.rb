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
  field :reviewer, type: String, default: nil

  embeds_many :comments, cascade_callbacks: true, inverse_of: :article
  embeds_one :permalink, inverse_of: :linkable, class_name: 'Permalink'
  belongs_to :author, class_name: 'User', inverse_of: :articles, index: true

  validates :title, presence: true

  validates_inclusion_of :status, in: [:pending], on: :create
  validates_inclusion_of :status, in: %i[approved rejected], on: :update

  validates_length_of :title, within: 8..16
  validates_length_of :content, minimum: 200

  validates_absence_of :deletion_date if Mongoid::Compatibility::Version.mongoid4_or_newer?

  validates_presence_of :reviewer, unless: -> { status == :pending }

  validates_absence_of :comments, unless: :allow_comments if Mongoid::Compatibility::Version.mongoid4_or_newer?

  index({title: 1 }, { unique: true, background: true})
  index({ published: 1 })

  accepts_nested_attributes_for :permalink
end
