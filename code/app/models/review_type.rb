class ReviewType < ActiveRecord::Base

  has_many :review_components

  def self.get_all()
    return ReviewType.all.order(sort: :asc)
  end

end
