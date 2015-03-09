class City < ActiveRecord::Base
  belongs_to :country
  belongs_to :currency
  has_many :restaurants
  has_many :profiles
  has_one :filter_city
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  def name_with_initial

    "#{id}. #{name}"
  end
end
