class Record
  include Mongoid::Document

  belongs_to :user, :inverse_of => :record
end