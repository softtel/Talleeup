class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  has_one :commentproduct, foreign_key: "reviewsproductuser_id"
  has_many :review_components

  def get_comment_product_byid()
    # data=Commentproduct.where("reviewsproductuser_id"=> commentid)
    data=Commentproduct.where('reviewsproductuser_id'=> self.id)
    if data.count()>0
      return data.first().content
    else
        return ""

    end
  end
  def get_id_comment_product_byid()
    # data=Commentproduct.where("reviewsproductuser_id"=> commentid)
    data=Commentproduct.where('reviewsproductuser_id'=> self.id)
    if data.count()>0
      return data.first().id
    else
      return ""
    end
  end
    def get_comment_createat()
      # data=Commentproduct.where("reviewsproductuser_id"=> commentid)
      data=Commentproduct.where('reviewsproductuser_id'=> self.id)
      if data.count()>0
        return data.first().created_at
      else
        return ""

      end

    end



  def self.add(user_id, product_id, totalpoint)
    review = Review.create(user_id: user_id, product_id: product_id, totalpoint: totalpoint)
    return review
  end

  def self.getReviewed(user_id, product_id)
    return Review.where(user_id: user_id, product_id: product_id).order(id: :desc).take(1)[0]
  end
  def self.getReviewedInfo(user_id, product_id)
    return Review.where(user_id: user_id, product_id: product_id).order(id: :desc).first()
  end
  def getReviewedId(user_id, product_id)
    return Review.where(user_id: user_id, product_id: product_id).order(id: :desc).first().id
  end
  def getComment()

      comment = Commentproduct.where(reviewsproductuser_id: self.id).order(id: :desc).first()
      if(comment.present?)
        return comment.content
      else
        return "";
      end

  end
  def getCommentImages()

    comment = Commentproduct.where(reviewsproductuser_id: self.id).order(id: :desc).first()
    if(comment.present?)
      return comment.images
    else
      return "";
    end

  end
  def get_reviewed_components()
    return ReviewComponent.where(review_id: self.id)
  end


  def get_numlink_comment_product_byid()
    # data=Commentproduct.where("reviewsproductuser_id"=> commentid)
    data=Commentproduct.where('reviewsproductuser_id'=> self.id)
    if data.count()>0
      return data.first().numlikes
    else
      return ""
    end
  end
  def self.save(upload)
    name =  upload.original_filename
    directory = "public/comment"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload.read) }
  end

end
