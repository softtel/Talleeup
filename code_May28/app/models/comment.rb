class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  has_attached_file :images, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :images, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif","image/PNG"]

  def self.add(product_id,content,imgaes,user_id)
    comment = Comment.create(content: content,images: imgaes,product_id:product_id,user_id:user_id)
  end
  def self.updatelike(id)
    comment = Comment.find(id)
    comment.numlikes = 1
    comment.save
  end
  def get_numlink_comment_product_byid()
    # data=Commentproduct.where("reviewsproductuser_id"=> commentid)
    data=Comment.where('id'=> self.id)
    if data.count()>0
      return data.first().numlikes
    else
      return ""
    end
  end
end
