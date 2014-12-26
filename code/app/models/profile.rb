class Profile < ActiveRecord::Base
  belongs_to :user
  belongs_to :city

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/profile/avatar/:style/no-avatar.png"
  validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif","image/PNG"]

  has_attached_file :cover_image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :cover_image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif","image/PNG"]

  def self.getProfile(user_id)
    return Profile.find_by user_id: user_id
  end

end
