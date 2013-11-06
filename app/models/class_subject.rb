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

  def get_lessons date = nil
    if date.present?
      month = date.month
      week_number = (date.day/7) 
      entries = class_schedule_entries.where(week: week_number, month: month)
      class_lessons = entries.map(&:lesson)
    else
      class_lessons = class_schedule_entries.map(&:lesson)
    end
    class_lessons
  end

  def subject_monthly_schedule month
    lessons_arr =[]
    (0..3).each do |week_no|
      entry = class_schedule_entries.where(month: month, week: week_no).first
      if entry.nil?
        entry = ClassScheduleEntry.new(month: month, week: week_no)
        entry.class_subject = self
      end
      lessons_arr[week_no] = entry
    end
    lessons_arr
  end


  def lesson_evaluated? lesson
    class_evaluation_records.where('lesson._id' => lesson._id).first.present?
  end


end