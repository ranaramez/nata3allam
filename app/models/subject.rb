class Subject
  include Mongoid::Document
  
  field :description, :type => String
  field :level, :type => String
  embeds_many :lessons, :class_name => "Lesson", :validate => false
  has_many :class_subjects, :class_name => "ClassSubject", :validate => false

end