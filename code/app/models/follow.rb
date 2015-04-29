class Follow < ActiveRecord::Base
  belongs_to :user

  def self.add(param_user_id, param_friend_id)
    follow = Follow.create(user_id: param_user_id, followed_user: param_friend_id)
  end

  def self.delete(param_user_id, param_friend_id)
    follow = Follow.where(user_id: param_user_id, followed_user: param_friend_id).limit(1)
    if(follow.present?)
      follow[0].destroy
    end
  end
  def self.getUserFllow(user_id)
      flloe=Follow.where(user_id:user_id)
  end

end
