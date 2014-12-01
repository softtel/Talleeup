class Restaurant < ActiveRecord::Base
    belongs_to :city
    has_many :products, inverse_of: :restaurant, dependent: :destroy
    # validates_associated :products
    # has_many :products, inverse_of: :restaurant
end
