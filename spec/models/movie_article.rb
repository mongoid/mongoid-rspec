class MovieArticle < Article

  field :rating, type: Float
  field :classification, type: Integer

  validates :rating, numericality: { greater_than: 0, less_than_or_equal_to: 5 }
  validates :classification, numericality: { even: true, only_integer: true, allow_nil: false }
end