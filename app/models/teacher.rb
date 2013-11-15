class Teacher < Person
  include Mongoid::Document

  has_and_belongs_to_many :n_class, :class_name => "NClass", :inverse_of => :class_teachers
  has_and_belongs_to_many :class_subject
  belongs_to :record
  
end