class Student < Person
  include Mongoid::Document

  belongs_to :n_class, :class_name => "NClass", :inverse_of => :students
  has_many :family_members, :class_name => "Person" #where to store the relation? 
  embeds_many :health_records, :class_name => "HealthRecord"
  has_many :evaluation_records, :class_name => "EvaluationRecord"
  has_many :assigned_behaviors, :class_name => "Behavior"
  has_many :student_behavior_records, :class_name => "StudentBehaviorRecord"
  #cache general evaluation record

  def template_behavior_record date
    record = student_behavior_records.where(from_date: date).first
    record ||= StudentBehaviorRecord.template self, date, assigned_behaviors
    record
  end


end