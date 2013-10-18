class Grade 
	include Mongoid::Document
  field :grade, type: Boolean, default: false
  field :general_comments, :type => String
  embeds_one :lesson, :class_name => "Lesson", :validate => false
  embedded_in :evaluation_record, :class_name => "EvaluationRecord", :inverse_of => "grades"

  accepts_nested_attributes_for :lesson,
    :allow_destroy => true,
    :reject_if     => :all_blank
  def self.template lesson
    Grade.new(lesson: lesson, grade: nil)
  end

end