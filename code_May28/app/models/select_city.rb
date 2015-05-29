class SelectCity < ActiveRecord::Base
  has_many :City
  has_many :countries
end
