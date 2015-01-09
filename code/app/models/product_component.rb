class ProductComponent < ActiveRecord::Base
  belongs_to :product
  belongs_to :component_value
end
