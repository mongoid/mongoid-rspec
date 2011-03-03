class Record
  include Mongoid::Document
  
  referenced_in :user, :inverse_of => :record
end  