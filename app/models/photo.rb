class Image
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :extension, :type => String
  mount_uploader :image, ImageUploader

  belongs_to :person
end