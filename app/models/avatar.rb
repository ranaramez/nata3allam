class Avatar
  include Mongoid::Document
  include Mongoid::Timestamps
  attr_accessible :person_id, :name, :avatar
  field :name, :type => String
  field :extension, :type => String
  mount_uploader :avatar, AvatarUploader
  
  belongs_to :person
end