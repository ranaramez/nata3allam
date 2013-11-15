class Relative
  include Mongoid::Document
  belongs_to :person, :class_name => "Person", :inverse_of => :relatives
  belongs_to :related, :class_name => "Person", :inverse_of => :relatives
  field :relation_type, :type => Symbol
end