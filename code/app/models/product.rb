class Product < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :category
  has_many :product_components
  has_many :reviews

  validates :name, :images, :restaurant_id, presence: true
  validates :prices, presence: true, numericality: true
  validates :restaurant, presence: true

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

  def get_reviewers
    return Review.where('product_id' => self.id).select(:user_id).distinct
  end

  def get_review_score
    reviews = Review.where('product_id' => self.id)
    return (reviews.count == 0) ? 0.0 : reviews.average("totalpoint")
  end

  def check_reviewed(user_id)
    first_day_of_month = Time.new(Time.now.year, Time.now.month, 1)
    reviewed = Review.where("user_id = ? AND product_id = ? AND  created_at >= ?", user_id, self.id,  first_day_of_month).count
    # @@is_reviewed = (reviewed > 0) ? true : false
    return (reviewed > 0) ? true : false
  end

end
