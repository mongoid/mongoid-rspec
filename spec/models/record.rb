require 'user'

class Record
  include Mongoid::Document

  belongs_to :user, inverse_of: :record, touch: :record_updated_at
end
