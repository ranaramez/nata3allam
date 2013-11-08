class StudentBehaviorRecord < Record

  belongs_to :student, :class_name => "Student", :inverse_of => :student_behavior_records
  has_many :behavior_records, :class_name => "BehaviorRecord"
  accepts_nested_attributes_for :behavior_records,
    :allow_destroy => true,
    :reject_if     => :all_blank
  def self.template student, date, behaviors
    student_record = StudentBehaviorRecord.new
    behaviors.each do |behavior|
      record = BehaviorRecord.new
      record.behavior = behavior
      record.student_behavior_record = student_record
      record.from_date = date
      record.to_date = date + 6
      student_record.behavior_records += [record]
    end
    student_record.student = student
    student_record
  end

end