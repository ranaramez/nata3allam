class Student < Person
  include Mongoid::Document
  field :sponsors_count, :type => Integer, :default => 0
  
  belongs_to :n_class, :class_name => "NClass", :inverse_of => :students
  has_many :past_classes, :class_name => "NClass"
  embeds_many :health_records, :class_name => "HealthRecord"
  has_many :evaluation_records, :class_name => "EvaluationRecord"
  has_many :assigned_behaviors, :class_name => "Behavior"
  has_many :student_behavior_records, :class_name => "StudentBehaviorRecord"
  #cache general evaluation record
  default_scope order_by([[:avatar, :desc]])

  def template_behavior_record date
    record = student_behavior_records.where(from_date: date).first
    record ||= StudentBehaviorRecord.template self, date, assigned_behaviors
    record
  end

  def get_student_class_report date
    student_report = {}
    return [{}, 0, 0] if n_class.nil?
    subjects = self.n_class.subjects
    total_lessons, total_done = 0, 0
    subjects.each do |subject|
      past_lessons = subject.get_past_lessons(date).uniq
      finished_records = self.evaluation_records.where(mastery: true) #TODO have to specify subject
      finished_lessons = finished_records.map{|i|i.class_evaluation_record.lesson}.uniq
      unfinished_lessons = past_lessons - finished_lessons
      finished_lessons_count = past_lessons.count - unfinished_lessons.count
      total_lessons += past_lessons.count
      total_done += finished_lessons_count

      student_report[subject._id] = [finished_lessons_count, past_lessons.count]
    end
    [student_report, total_done, total_lessons]
  end

  def get_student_progress
    student_report = {}
    return {} if n_class.nil?
    subjects = self.n_class.subjects
    subjects.each do |subject|
      lessons = subject.lessons
      finished_records = self.evaluation_records.where(mastery: true) #TODO have to specify subject
      finished_lessons = finished_records.map{|i|i.class_evaluation_record.lesson}
      unfinished_lessons = lessons - finished_lessons
      finished_lessons_count = lessons.count - unfinished_lessons.count
      percentage = finished_lessons_count * 100 / lessons.count
      student_report[subject.description] = percentage
    end
    student_report
  end

  def get_detailed_subject_report subject
    lessons = subject.lessons
    lesson_ids = lessons.map(&:_id)
    #TODO(nazly) get lesson directly
    evaluation_records = self.evaluation_records.select {|i| lesson_ids.include? i.class_evaluation_record.lesson._id}
    evaluation_records
  end

  def get_student_past_classes_report  date
    student_report = {}
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
        student_report[p_class.start_year] = {} if student_report[p_class.start_year].nil?
        student_report[p_class.start_year].merge!({ subject => [finished_lessons_count, past_lessons.count] })
      end
    end
    student_report
  end

end