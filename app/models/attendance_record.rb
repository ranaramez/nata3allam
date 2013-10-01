class AttendanceRecord < Record

  include Mongoid::Document
  field :present, :type => Boolean, :default => false
  belongs_to :student, :class_name => "Student", :inverse_of => nil
  belongs_to :class_attendance_record, :class_name => "ClassAttendanceRecord", :inverse_of => :attendance_records
end