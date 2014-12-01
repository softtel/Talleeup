class Country < ActiveRecord::Base
  has_many :cities
  has_many :cities, :through=> :cities
  accepts_nested_attributes_for :cities, :allow_destroy => true
  validates :name, presence: true

end
