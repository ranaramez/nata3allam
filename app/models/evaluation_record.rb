class EvaluationRecord < Record

  include Mongoid::Document
  field :grade, :type => Boolean, :default => false
  belongs_to :student, :class_name => "Student", :inverse_of => :evaluation_records
  belongs_to :class_evaluation_record, :class_name => "ClassEvaluationRecord", :inverse_of => :evaluation_records

end