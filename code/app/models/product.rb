class Product < ActiveRecord::Base

  belongs_to :restaurant
  belongs_to :category
  has_many :product_components, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_many :product_images, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  validates :name, :images, :restaurant_id, presence: true
  validates :prices, presence: true, numericality: true
  validates :restaurant, presence: true


  include PgSearch
  pg_search_scope :whose_name_starts_with,
                  :against => :name,
                  :using => {
                      :tsearch => {:prefix => true}
                  }

  pg_search_scope :with_name_matching,
                  :against => :name,
                  :using => {
                      :tsearch => {:negation => true}
                  }

  has_attached_file :images, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :images, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif","image/PNG"]

  def self.get_products(_city_id, _limit = 1000)
    return Product.find_by_sql("SELECT products.*, CASE WHEN table_reviews.product_id IS NULL THEN 0.0 ELSE table_reviews.review_score END AS review_score
                                FROM products
                                JOIN (SELECT * FROM restaurants WHERE city_id = #{_city_id}) AS table_restaurant ON products.restaurant_id = table_restaurant.id
                                LEFT JOIN (SELECT product_id, AVG(totalpoint) as review_score FROM reviews GROUP BY reviews.product_id) AS table_reviews ON products.id = table_reviews.product_id
                                ORDER BY  review_score DESC
                                LIMIT #{_limit}")
  end

  def self.search(_keyword)#,city_id)
      return Product.find_by_sql("SELECT distinct p.*
      FROM  products p
      JOIN restaurants rs ON p.restaurant_id=rs.id
      WHERE  lower(p.name) like '%#{_keyword.downcase}%'") #and rs.city_id=#{city_id}
   # ")
     #return Product.joins(:restaurants).where("products.name like ?"=> "%#{_keyword}%","restaurants.city_id"=>city_id)
    #return (Product.with_name_matching(_keyword) + Product.whose_name_starts_with(_keyword)).uniq
  end

  def get_reviewers
    data=Review.where('product_id' => self.id).select(:user_id).distinct
    return data
  end

  def get_review_score
    reviews = Review.where('product_id' => self.id)
    return (reviews.count == 0) ? 0.0 : reviews.average("totalpoint")
  end
  def getMaxReview
    reviews = Review.where('product_id' => self.id)
    return (reviews.count == 0) ? 0 : reviews.maximum("totalpoint")
  end
  def getMinReview
    reviews = Review.where('product_id' => self.id)
    return (reviews.count == 0) ? 0 : reviews.minimum("totalpoint")
  end

  def check_reviewed(user_id)
    first_day_of_month = Time.new(Time.now.year, Time.now.month, 1)

    reviewed = Review.where("user_id = ? AND product_id = ?", user_id, self.id).order(id: :desc)
    if reviewed.length>0
      date_now=(Time.now - reviewed.first().created_at.to_time)/1.day
      if date_now <=30 and date_now >0
        return  true
      else
        return false
      end
    else
      return false
    end

  end
  def self.check_reviewed_detals(user_id,_id)

    reviewed = Review.where("user_id = ? AND product_id = ?", user_id, _id).order(id: :desc)
    if reviewed.length>0
      date_now=(Time.now - reviewed.first().created_at.to_time)/1.day
      if date_now <=30 and date_now >0
        return  true
      else
        return false
      end
    else
      return false
    end

  end
  def getnumberdemo(user_id)


    reviewed = Review.where("user_id = ? AND product_id = ?", user_id, self.id)
    if reviewed.length>0
      date_now=(Time.now - reviewed.first().created_at.to_time)/1.day

      return  date_now
    else
      return 0
    end


  end
  def self.get_socre_average_product_byid(productid,_num)
    reviews = Review.where('product_id' => productid)
    return (reviews.count == 0) ? 0.0 : reviews.average("totalpoint").round(_num)
  end
  def self.get_count_user_review_byIcProduct(productid)
    return Review.where(product_id: productid).select(:user_id).distinct.count()
  end
  def self.get_product_Byid(productid)
    return Product.where(id: productid).first()
  end
  def self.update_views_product_byid(product_id)
      product=Product.find_by(id: product_id)
      product.numviews= product.numviews+1
      product.save
  end
  def self.get_score_product_groupByuserId(productid,_num)
    reviews =Review.find_by_sql("select  *
                                from reviews
                                where id = (
                                            select max(id)
                                            from reviews as f
                                            where f.product_id = #{productid} and f.user_id = reviews.user_id)  ORDER by created_at DESC limit #{_num}")

    return reviews
  end

end
