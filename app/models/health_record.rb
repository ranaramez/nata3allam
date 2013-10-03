class HealthRecord < Record

  include Mongoid::Document
  
  #field :height, :type => Float
  #field :weight, :type => Float
  #field :pulse_rate, :type => Integer
  #field :respiratory_rate, :type => Integer
  embedded_in :student, :class_name => "Student", :inverse_of => "health_records"

end