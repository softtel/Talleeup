class FilterCity < ActiveRecord::Base
  belongs_to :city
  belongs_to :country
end
