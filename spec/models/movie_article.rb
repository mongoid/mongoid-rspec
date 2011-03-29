class MovieArticle < Article
  field :rating, :type => Integer
  validates_numericality_of :rating, :greater_than => 0, :less_than => 6
end