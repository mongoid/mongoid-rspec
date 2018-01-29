class Log
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic if Mongoid::Compatibility::Version.mongoid4_or_newer?

  store_in collection: 'logs'

  index({ created_at: 1 }, bucket_size: 100, expire_after_seconds: 3600)
end
