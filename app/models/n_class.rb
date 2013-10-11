class NClass

  include Mongoid::Document
  
  field :name, :type => String
  has_one :class_teacher, :class_name => "Teacher", :validate => true
  has_many :subjects, :class_name => "ClassSubject", :validate => false
  has_many :students, :class_name => "Student", :validate => false

  validates_presence_of :class_teacher
  def teacher_name
  	teacher = class_teacher
  	if teacher.present?
  		return teacher.first_name.to_s + " " + teacher.last_name.to_s
  	end
  	return "none"
  end

  def class_monthly_schedule month
    subjects_hash = {}
    subjects.each do |subject|
      subjects_hash[subject] = subject.subject_monthly_schedule month
    end
    subjects_hash
  end

end