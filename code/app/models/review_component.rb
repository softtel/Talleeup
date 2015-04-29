class ReviewComponent < ActiveRecord::Base
  belongs_to :review_type

  def self.add(review_id, review_type_id, point)
    reviewComponent = ReviewComponent.create(review_id: review_id, review_type_id: review_type_id, point: point)
    return reviewComponent
  end

end
