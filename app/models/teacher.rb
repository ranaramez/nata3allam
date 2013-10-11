class Teacher < Person
  include Mongoid::Document

  belongs_to :n_class, :class_name => "NClass", :inverse_of => :class_teacher
  has_and_belongs_to_many :class_subject
  belongs_to :record
  
end