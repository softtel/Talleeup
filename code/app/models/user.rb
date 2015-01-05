class User < ActiveRecord::Base
  has_one :profile
  has_many :reviews
  has_many :follows
  has_many :comments
  has_many :meta_users

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, #:confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2, :twitter]

  after_create :create_profile

  def create_profile
    profile = Profile.create(user_id: self.id)
    # Maybe check if profile gets created and raise an error
    #  or provide some kind of error handling
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.fullname = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.uid + "@twitter.com").first
      if registered_user
        return registered_user
      else

        user = User.create(fullname:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.uid+"@twitter.com",
                           password:Devise.friendly_token[0,20],
        )
      end

    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def get_news(limit = 1000)
    return Review.find_by_sql("SELECT reviews.*
                                FROM (SELECT followed_user FROM follows WHERE user_id = #{self.id}) as listUserIdFollowed
                                JOIN reviews ON listUserIdFollowed.followed_user = user_id
                                ORDER BY reviews.id DESC
                                LIMIT #{limit}")
  end

  def get_products_reviewed(limit = 1000)
    return Product.joins(:reviews).where(reviews: {user_id: self.id}).limit(limit).distinct
  end

  def isFollowed(friend_id)
    count = Follow.where("user_id = ? AND followed_user = ?", self.id, friend_id).limit(1).count
    if(count == 0)
      return false
    else
      return true
    end
  end


  def get_numFollows
    return Follow.where("followed_user = ?", self.id).select(:followed_user).distinct.count(:followed_user)
  end

  def get_numBuggerReviewed
    return Review.where("user_id = ?", self.id).select(:product_id).distinct.count(:product_id)
  end

  def get_involvement

    case get_numBuggerReviewed()
      when 0..4
        return "Apprentice"
      when 5..19
        return "Journeyman"
      else
        return "Master"
    end
  end


end
