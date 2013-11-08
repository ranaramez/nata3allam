class Student < Person
  include Mongoid::Document

  belongs_to :n_class, :class_name => "NClass", :inverse_of => :students
  has_many :past_classes, :class_name => "NClass"
  has_many :family_members, :class_name => "Person" #where to store the relation? 
  embeds_many :health_records, :class_name => "HealthRecord"
  has_many :evaluation_records, :class_name => "EvaluationRecord"
  has_many :assigned_behaviors, :class_name => "Behavior"
  has_many :student_behavior_records, :class_name => "StudentBehaviorRecord"
  #cache general evaluation record

  def template_behavior_record date
    record = student_behavior_records.where(from_date: date).first
    record ||= StudentBehaviorRecord.template self, date, assigned_behaviors
    record
  end

  def get_student_class_report date
    student_report = {}
    subjects = self.n_class.subjects
    total_lessons, total_done = 0, 0
    subjects.each do |subject|
      past_lessons = subject.get_past_lessons date
      finished_records = self.evaluation_records.where(mastery: true) #TODO have to specify subject
      finished_lessons = finished_records.map{|i|i.class_evaluation_record.lesson}
      unfinished_lessons = past_lessons - finished_lessons
      finished_lessons_count = past_lessons.count - unfinished_lessons.count
      total_lessons += past_lessons.count
      total_done += finished_lessons_count
      student_report[subject._id] = [finished_lessons_count, past_lessons.count]
    end
    [student_report, total_done, total_lessons]
  end

  def get_student_past_classes_report  date
    student_report = {}
    student_report.default = {}
    past_classes.each do |p_class|
      subjects = p_class.subjects
      total_lessons, total_done = 0, 0
      subjects.each do |subject|
        past_lessons = subject.get_past_lessons date
        finished_records = self.evaluation_records.where(mastery: true) #TODO (specify class subject)
        finished_lessons = finished_records.map{|i|i.class_evaluation_record.lesson}
        unfinished_lessons = past_lessons - finished_lessons
        finished_lessons_count = past_lessons.count - unfinished_lessons.count
        total_lessons += past_lessons.count
        total_done += finished_lessons_count
        student_report[p_class.start_year].merge!({ subject._id => [finished_lessons_count, past_lessons.count] })
      end
    end
    student_report
  end

end