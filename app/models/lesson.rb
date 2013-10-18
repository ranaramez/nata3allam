class Lesson

  include Mongoid::Document

  field :description, :type => String
  field :performance_metrics, :type => Hash #hash /just metrics and constant grading system
  embedded_in :class_subject, :class_name => "ClassSubject", :inverse_of => "lessons"
  embedded_in :subject, :class_name => "Subject", :inverse_of => "lessons"
  embedded_in :grade, :class_name => "Grade", :inverse_of => "lesson"
  embedded_in :class_schedule_entry, :class_name => "ClassScheduleEntry", :inverse_of => "lesson"
end