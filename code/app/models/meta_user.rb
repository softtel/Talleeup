class MetaUser < ActiveRecord::Base

  belongs_to :user
  belongs_to :meta

  def self.update_profile(id, value)
    meta_user = MetaUser.find(id)
    meta_user.update(value: value)
  end

end
