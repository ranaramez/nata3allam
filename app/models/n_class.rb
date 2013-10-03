class NClass

  include Mongoid::Document
  
  field :name, :type => String
  has_one :class_teacher, :class_name => "Teacher", :validate => false
  has_many :subjects, :class_name => "ClassSubject", :validate => false
  has_many :students, :class_name => "Student", :validate => false

end