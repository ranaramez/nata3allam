class NClass

  include Mongoid::Document
  
  field :name, :type => String
  has_one :class_teacher, :class_name => "Teacher", :validate => true
  has_many :subjects, :class_name => "ClassSubject", :validate => false
  has_many :students, :class_name => "Student", :validate => false
  belongs_to :student, :class_name => "Student", :inverse_of => :past_classes
  
  field :start_year, :type => Integer, :default =>  Date.today.year 

  validates_presence_of :class_teacher
  def teacher_name
  	teacher = class_teacher
  	if teacher.present?
  		return teacher.full_name
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

  def get_students_class_report date
    students_class_report = {}
    students_class_report.default = []
    subjects.each do |subject|
      past_lessons = subject.get_past_lessons date
      students.each do |student|
        finished_records = student.evaluation_records.where(mastery: true)
        finished_lessons = finished_records.map{|i|i.class_evaluation_record.lesson}
        unfinished_lessons = past_lessons - finished_lessons
        students_class_report[student._id] += [unfinished_lessons]
      end
    end
    students_class_report
  end

end