class ClassEvaluationRecord < Record
  include Mongoid::Document

  has_many :evaluation_records, class_name: "EvaluationRecord", :validate => false
  embeds_one :lesson, :class_name => "Lesson", :validate => false
  belongs_to :class_subject
end