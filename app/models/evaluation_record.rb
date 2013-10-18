class EvaluationRecord < Record

  include Mongoid::Document
  embeds_many :grades, :class_name => "Grade", :validate => false 
  belongs_to :student, :class_name => "Student", :inverse_of => :evaluation_records
  belongs_to :class_evaluation_record, :class_name => "ClassEvaluationRecord", :inverse_of => :evaluation_records

  accepts_nested_attributes_for :grades,
    :allow_destroy => true,
    :reject_if     => :all_blank

  def self.template(class_subject, student)
  	record = EvaluationRecord.new
  	record.student = student
  	class_subject.get_lessons.each do |lesson|
  		record.grades << Grade.template(lesson)
  	end
  	record
  end

  def get_student_grades lessons
    lesson_grades = []
    lessons.each do |lesson|
      grade = self.grades.where('lesson._id' => lesson._id).first
      grade ||= Grade.template(lesson)
      lesson_grades += [grade]
    end
    lesson_grades
  end

end