class User < Person
  include Mongoid::Document
  field :username, :type => String
  field :email,  :type => String
  field :password

  validates_presence_of :username
  validates_uniqueness_of :username, :email
  belongs_to :record, class_name: "Record", :inverse_of => :creator

end