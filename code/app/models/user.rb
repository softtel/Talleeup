class User < ActiveRecord::Base
  has_one :profile
  has_many :reviews

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  def get_products_reviewed
    return Product.joins(:reviews).where(reviews: {user_id: self.id}).distinct
  end

end
