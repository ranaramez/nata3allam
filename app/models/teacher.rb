class Teacher < Person

  include Mongoid::Document
  belongs_to :n_class, :class_name => "NClass", :inverse_of => :class_teacher
  belongs_to :class_subject
  belongs_to :record
end