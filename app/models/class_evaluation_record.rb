class ClassEvaluationRecord < Record
  include Mongoid::Document

  has_many :evaluation_records, class_name: "EvaluationRecord", :validate => false
  belongs_to :class_subject

	accepts_nested_attributes_for :evaluation_records,
    :allow_destroy => true,
    :reject_if     => :all_blank

  def self.template(class_subject, students)
  	record = ClassEvaluationRecord.new
  	record.class_subject = class_subject
  	students.each do |student|
      student_record = EvaluationRecord.template class_subject, student
  		student_record.class_evaluation_record = record
  	end
  	record
  end

  def student_record student
    evaluation_records.where('student._id' => student._id).first
  end

end