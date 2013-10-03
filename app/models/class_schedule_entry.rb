class ClassScheduleEntry
  include Mongoid::Document
  field :week, :type => Integer
  field :month, :type => Integer
  embeds_one :lesson, :class_name => "Lesson", :validate => false
  belongs_to :class_subject, :class_name => "ClassSubject", :inverse_of => :class_schedule_entries
end