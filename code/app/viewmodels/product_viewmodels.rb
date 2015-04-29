class ProductViewModels# < Product
  attr_accessor :total_review
  def initialize(total_review)
    @total_review = total_review
  end
end