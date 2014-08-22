class Request
  include Mongoid::Document

  field :name, :type => String
  field :email, :type => String
  field :contacts, :type => String
  field :comments, :type => String
  belongs_to :student, :class_name => "Student", :inverse_of => nil

end