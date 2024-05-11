require 'article'

class Permalink
  include Mongoid::Document

  embedded_in :linkable,
              inverse_of: :link,
              touch: false
end
