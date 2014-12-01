class Product < ActiveRecord::Base
  belongs_to :restaurant

  validates :name, :images, :restaurant_id, presence: true
  validates :prices, presence: true, numericality: true
  validates :restaurant, presence: true

  has_attached_file :images, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :images, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif","image/PNG"]
end
