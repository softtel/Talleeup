class Meta < ActiveRecord::Base
  validates :name, :datatype, presence: true
  has_many :meta_user

  def self.get_datatype
    return [ 'text', 'url' ]
  end

  def self.get_meta
    return Meta.all.order(:sort)
  end

  def get_meta_user(user_id)
    metaUser = MetaUser.where(user_id: user_id, meta_id: self.id).limit(1)[0]
    if metaUser.present?
      return metaUser
    else
      return MetaUser.create(user_id: user_id, meta_id: self.id)
    end
  end
end
