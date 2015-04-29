class Component < ActiveRecord::Base
  has_many :component_values
  has_one :filter
  accepts_nested_attributes_for :component_values

  def getcomponentvalueBycomponentID(productid)
    data=ComponentValue.find_by_sql("
      SELECT distinct v.*
      FROM product_components c
      JOIN component_values v on c.component_value_id=v.id
      WHERE v.component_id=#{self.id} and c.product_id=#{productid}
    ")

    a=""
    data.each do |item|
      if a.empty?
        a=item.name
      else
        a=a+","+item.name
      end

    end
    return a
  end
  def getvalue()
    data=ComponentValue.where(component_id: self.id)
    return data
  end
end
