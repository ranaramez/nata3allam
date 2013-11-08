class Person
  
  include Mongoid::Document
  include ActiveModel::SecurePassword

  field :first_name, :type => String
  field :last_name, :type => String
  field :address, :type => String
  field :date_of_birth, :type => Time
  field :gender, :type => Symbol
  field :job, :type => String
  field :educational_background, :type => String #certain values?
  field :contacts, :type => String
  field :national_id, :type => String
  belongs_to :student


  validates_presence_of :first_name

  def full_name
    first_name.to_s + " " + last_name.to_s
  end
end