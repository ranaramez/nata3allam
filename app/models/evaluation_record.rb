class EvaluationRecord < Record

  include Mongoid::Document

  # TODO => make grades more generic
  field :presentation, :type => Boolean, :default => false
  field :training, :type => Integer, :default => 0
  field :mastery, :type => Boolean, :default => false

  belongs_to :student, :class_name => "Student", :inverse_of => :evaluation_records
  belongs_to :class_evaluation_record, :class_name => "ClassEvaluationRecord", :inverse_of => :evaluation_records
  embeds_one :lesson, :class_name => "Lesson", :validate => false
  

  def self.template(lesson, student)
  	record = EvaluationRecord.new
  	record.student = student
  	record.lesson = lesson
  	record
  end


end