class ProductComponent < ActiveRecord::Base
  belongs_to :products
  belongs_to :component_value
end
