class Log
  include Mongoid::Document
  store_in collection: "logs"
end