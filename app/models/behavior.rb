class Behavior

  include Mongoid::Document
  
  field :description, :type => String
  belongs_to :student, :class_name => "Student", :validate => true
  has_many :behavior_records, :class_name => "BehaviorRecord"


end