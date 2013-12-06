class Image
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :extension, :type => String
  mount_uploader :image, AvatarUploader

  belongs_to :person
end