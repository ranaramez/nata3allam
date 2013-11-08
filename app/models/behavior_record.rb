class BehaviorRecord < Record

  field :level, :type => Integer
  belongs_to :behavior, :class_name => "Behavior", :inverse_of => :behavior_records
  belongs_to :student_behavior_record, :class_name => "StudentBehaviorRecord", :inverse_of => :behavior_records
  accepts_nested_attributes_for :behavior,
    :allow_destroy => true,
    :reject_if     => :all_blank

end