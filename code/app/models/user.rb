class User < ActiveRecord::Base
  has_one :profile
  has_many :reviews
  has_many :follows
  has_many :comments
  has_many :meta_users

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2, :twitter,:github]

  after_create :create_profile

  def create_profile
    profile = Profile.create(user_id: self.id)
    # Maybe check if profile gets created and raise an error
    #  or provide some kind of error handling
  end

  def self.find_for_facebook_oauth(auth)

    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else

        user = User.create(fullname:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20],
                           confirmed_at: DateTime.now
        )
      end
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
                           confirmed_at: DateTime.now
        )
      end

    end
  end

  def self.find_for_google_oauth2(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else

      domain_mail = "@gmail.com"

      registered_user = User.where(:email => auth.uid + domain_mail).first
      if registered_user
        return registered_user
      else

        user = User.create(fullname:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.uid+domain_mail,
                           password:Devise.friendly_token[0,20],
                           confirmed_at: DateTime.now
        )

        return user
      end

    end
  end
  def self.find_for_github_oauth(auth)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else

        user = User.create(fullname:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20],
                           confirmed_at: DateTime.now
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
  def self.get_products_reviewedAll(limit = 1000)
    return Product.joins(:reviews).limit(limit).distinct
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
      when 0..5
        return "Associate"
      when 6..10
        return "Soldier"
      when 11..15
        return "Caporegime"
      when 16..20
        return "Underboss"
      else
        return "Boss"
    end
  end
  def self.check_issame(_email)
    _data=User.where(email: _email)

  end
  def self.from_omniauth(auth, current_user)
    authorization = Authorization.where(:provider => auth.provider, :uid => auth.uid.to_s, :token => auth.credentials.token, :secret => auth.credentials.secret).first_or_initialize
    if authorization.user.blank?
      user = current_user.nil? ? User.where('email = ?', auth["info"]["email"]).first : current_user
      if user.blank?
        user = User.new
        user.password = Devise.friendly_token[0,10]
        user.name = auth.info.name
        user.email = auth.info.email
        auth.provider == "twitter" ?  user.save(:validate => false) :  user.save
      end
      authorization.username = auth.info.nickname
      authorization.user_id = user.id
      authorization.save
    end
    authorization.user
  end
  def self.find_for_github_oauth(auth)

    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else

        user = User.create(fullname:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20],
                           confirmed_at: DateTime.now
        )
      end
    end


  end
end
