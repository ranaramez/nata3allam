class Record
	include Mongoid::Document

	field :from_date, :type => Date
  field :to_date, :type =>Date
  field :date_of_entry, :type => Date
  field :general_comments, :type => String
  has_one :creator, class_name: "User", :validate => false
  has_one :supervising_teacher, class_name: "Teacher", :validate => false
end