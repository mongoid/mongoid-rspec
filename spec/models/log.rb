class Log
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  store_in collection: "logs"
end
