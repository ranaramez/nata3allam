class User < Person
  include Mongoid::Document

  # Devise Attributes
  ## Database authenticatable
  field :email
  field :encrypted_password
  ## Rememberable
  field :remember_created_at, type: Time

  field :username, :type => String

  devise :database_authenticatable, :validatable, :rememberable

  validates_presence_of :username
  validates_uniqueness_of :username, :email
  belongs_to :record, class_name: "Record", :inverse_of => :creator

end