class Person
  
  include Mongoid::Document
  include Mongoid::Slug
  include ActiveModel::SecurePassword

  field :first_name, :type => String
  field :last_name, :type => String
  field :full_name_generated, :type => String 
  field :address, :type => String
  field :date_of_birth, :type => Time
  field :national_id, :type => String
  field :gender, :type => Symbol
  field :job, :type => String
  field :educational_background, :type => String #certain values?
  field :contacts, :type => String
  has_many :relatives, :class_name => "Relative", validate: false
  belongs_to :student

  scope :father, where(gender: :male)
  scope :mother, where(gender: :female)
  validates_presence_of :first_name

  # Extensions
  mount_uploader :avatar, AvatarUploader
  slug :first_name, :last_name

  accepts_nested_attributes_for :relatives

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

  def avatar_large_url
    if self.avatar.present?
      self.avatar.large.url
    else
      person_gender = self.gender || :male
      "/defaults/students/avatar/#{person_gender}.png"
    end

  end

  def age
    if date_of_birth.present?
      Time.now.year - date_of_birth.year
    else
      nil
    end
  end

end