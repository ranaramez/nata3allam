class Student < Person

  include Mongoid::Document

  belongs_to :n_class, :class_name => "NClass", :inverse_of => :students
  has_many :family_members, :class_name => "Person" #where to store the relation? 
  embeds_many :health_records, :class_name => "HealthRecord"
  has_many :evaluation_records, :class_name => "EvaluationRecord"
  #cache general evaluation record

end