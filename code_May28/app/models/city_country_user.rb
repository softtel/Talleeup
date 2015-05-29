class CityCountryUser < ActiveRecord::Base

  def  self.insert_prodile(id,_val,user_id,_type)
      CityCountryUser.create(country_id: _val,user_id: user_id,type_option: _type)
  end
  def self.update_prodile(id,_val)
    up=CityCountryUser.find_by(id: id)
    up.update(country_id: _val)
  end
end
