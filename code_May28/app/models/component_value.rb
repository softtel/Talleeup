class ComponentValue < ActiveRecord::Base
  belongs_to :component
  has_many :product_components
  #validates :component, :component_id, presence: true

  accepts_nested_attributes_for :component
  def self.getcomponentvalue_byproductId(productid)
    data=ComponentValue.select(:component_id,:id).find_by_sql("
      SELECT v.component_id,v.id
      FROM product_components c
      JOIN component_values v on c.component_value_id=v.id
      WHERE c.product_id=#{productid}
    ")
    array=[]
    data.each do |item|
      array.push(item.component_id)
    end
    ff=  array.uniq
    #_datachil=Component.find_by_sql("
    #SELECT *
    #FROM components
    #WHERE id in #{ANY(array(ff))}
#")
    _datachil=Component.where(id: ff)
    return _datachil
  end

end
