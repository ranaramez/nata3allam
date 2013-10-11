class ClassSubject

	include Mongoid::Document

  field :description, :type => String
  has_and_belongs_to_many :subject_teachers, :class_name => "Teacher", :validate => false
  embeds_many :lessons, :class_name => "Lesson", :validate => false #TODO (schedule representation)
  has_many :class_evaluation_records, :class_name => "ClassEvaluationRecord", :validate => false
  has_many :class_attendance_records, :class_name => "ClassAttendanceRecord", :validate => false
  has_many :class_schedule_entries, :class_name =>"ClassScheduleEntry", :validate => false
  belongs_to :n_class, :class_name => "NClass", :inverse_of => :subjects
  belongs_to :subject

  def teachers_names
  	names  = ""
  	if subject_teachers.present?
  		names = subject_teachers.map{|t| t.first_name+" "+t.last_name}.join(', ')
  	end
  	names
  end

  def get_lessons_desc date = nil
    if date.present?
      month = date.month
      week_number = (date.day/7) + 1
      entries = class_schedule_entries.where(week: week_number, month: month)
      class_lessons = entries.map(&:lesson)
    else
      class_lessons = lessons
    end
    class_lessons.map(&:description)
  end

  def subject_monthly_schedule month
    entries = class_schedule_entries.where(month: month)
    lessons_hash ={}
    entries.each do |entry|
      lessons_hash[entry.week] = entry.lesson.description
    end
    lessons_hash
  end

end