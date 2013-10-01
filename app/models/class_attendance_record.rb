class ClassAttendanceRecord < Record

  include Mongoid::Document
  has_many :attendance_records, class_name: "AttendanceRecord", :validate => false
  embeds_one :lesson, :class_name => "Lesson", :validate => false
  belongs_to :class_subject

end