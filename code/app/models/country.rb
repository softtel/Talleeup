class Country < ActiveRecord::Base
  has_many :cities
  has_many :cities, :through=> :cities
  has_one :filter_city
  accepts_nested_attributes_for :cities, :allow_destroy => true
  validates :name, presence: true

end
