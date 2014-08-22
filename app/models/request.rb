class Request
  include Mongoid::Document

  field :name, :type => String
  field :email, :type => String
  field :contacts, :type => String
  field :comments, :type => String
  field :closed, :type => Boolean, :default => false
  belongs_to :student, :class_name => "Student", :inverse_of => nil
  field :created_at, :type => Float
  

  def self.get_requests start_date, end_date
    Request.all.where(:created_at => {'$gte' => start_date.to_f,'$lte' => end_date.to_f })
  end
end