class Comment
  include Mongoid::Document

  embedded_in :article, :inverse_of => :comments
  referenced_in :user, :inverse_of => :comments
end