class Location < ActiveRecord::Base
  def self.Add(user_id,country,city,address,ip)
    Location.create(user_id:user_id,country:country,city:city,address:address,ip:ip)
  end
end
