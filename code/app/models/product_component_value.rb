class ProductComponentValue < ActiveRecord::Base
  belongs_to :product_component
  validates :product_component, :product_component_id, presence: true
end
