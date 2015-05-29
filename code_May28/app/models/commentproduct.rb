class Commentproduct < ActiveRecord::Base
  belongs_to :review, foreign_key: "reviewsproductuser_id"

  def self.add(review_id, content, images)
    comment = Commentproduct.create(reviewsproductuser_id: review_id, content: content,images: images)
  end

  def self.updatelike(id)
    comment = Commentproduct.find(id)
    comment.numlikes = 1
    comment.save
  end
  def GetNumlike
    Commentproduct.where(id: self.id).select(:numlikes)
  end
end
