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
  field :avatar_url,  :type => String
  has_many :relatives, :class_name => "Relative", validate: false
  belongs_to :student

  scope :father, where(gender: :male)
  scope :mother, where(gender: :female)
  validates_presence_of :first_name

  mount_uploader :avatar, AvatarUploader

  def full_name
    first_name.to_s + " " + last_name.to_s
  end

  def father
    father_relation = relatives.where('person_id' => self._id, relation_type: :father).first
    return father_relation.related if father_relation.present?
    nil
  end

  def mother
    mother_relation = relatives.where('person_id' => self._id, relation_type: :mother).first
    return mother_relation.related if mother_relation.present?
    nil
  end

end