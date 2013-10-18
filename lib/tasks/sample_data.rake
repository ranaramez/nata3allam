#!/bin/env ruby
# encoding: utf-8
namespace :sample_data do
  task :generate => :environment do 

    #Mongoid.master.collections.reject { |c| c.name =~ /^system/}.each(&:drop)
    Person.all.destroy
    User.all.destroy
    Student.all.destroy
    Subject.all.destroy
    Teacher.all.destroy
    ClassSubject.all.destroy
    NClass.all.destroy
    ClassEvaluationRecord.all.destroy
    EvaluationRecord.all.destroy
    ClassAttendanceRecord.all.destroy
    AttendanceRecord.all.destroy
    ClassScheduleEntry.all.destroy

    people = make_people
    users = make_users
    students = make_students(people)
    subjects = make_subjects
    teachers = make_teachers
    class_subjects = make_class_subjects(teachers, subjects)
    classes = make_classes(teachers, students, class_subjects)
    #class_evaluation_records = make_class_evaluation_records(students, class_subjects)
    class_attendance_records = make_class_attendance_records(students, class_subjects)
    make_class_subject_schedule(class_subjects)
  end
end

def make_people 
  puts "Creating people"
  people = [] 
  number = 10
  number.times do |n|
    fn = Faker::Name.first_name
    ln = Faker::Name.last_name
    name = "#{fn} #{ln}"
    people << Person.create!( :first_name => fn,
                              :last_name => ln,
                              :address => Faker::Address.secondary_address,
                              :gender => [:male, :female].sample,
                              :educational_backround => Faker::Lorem.sentence,
                              :job => Faker::Lorem.sentence,
                              :contacts => Faker::PhoneNumber.phone_number
                            )
  end
  
  return people

end

def make_users
  puts "Creating Users"
  users = []
  number = 10 
  number.times do |n|
    fn = Faker::Name.first_name
    ln = Faker::Name.last_name
    name = "#{fn} #{ln}"
    users << User.create!( :first_name => fn,
                              :last_name => ln,
                              :username => Faker::Internet.user_name(name).sub(".","_"),
                              :email => Faker::Internet.email(name),
                              :password=> 'please123',
                              :address => Faker::Address.secondary_address,
                              :gender => [:male, :female].sample,
                              :educational_backround => Faker::Lorem.sentence,
                              :contacts => Faker::PhoneNumber.phone_number
                            )
  end
  
  return users
end

def make_students (people)
  puts "Creating students"
  students = [] 
  number = 100
  number.times do |n|
    fn = Faker::Name.first_name
    ln = Faker::Name.last_name
    name = "#{fn} #{ln}"
    student = Student.create!( :first_name => fn,
                              :last_name => ln,
                              :address => Faker::Address.secondary_address,
                              :gender => [:male, :female].sample,
                              :educational_backround => Faker::Lorem.sentence,
                              :contacts => Faker::PhoneNumber.phone_number
                            )
    relatives_count = [1,2,3].sample
    relatives_count.times do |t|
      relative =  people.sample
      student.family_members += [relative] if not student.family_members.include? relative
    end
    student.save!
    students << student
  end
  return students
end

def make_teachers
  puts "Creating teachers"
  teachers_names = ["ميس  انشراح",  "ميس ميسا", "ميس إيمان" ,"ميس كاميليا"]
  people = [] 
  number = 10
  number.times do |n|
    fn = Faker::Name.first_name
    ln = Faker::Name.last_name
    name = "#{fn} #{ln}"
    teacher = Teacher.create!( :first_name => teachers_names.sample,
                              :last_name => "",
                              :address => Faker::Address.secondary_address,
                              :gender => [:male, :female].sample,
                              :educational_backround => Faker::Lorem.sentence,
                              :job => Faker::Lorem.sentence,
                              :contacts => Faker::PhoneNumber.phone_number
                            )
    people << teacher
  end
  
  return people

end

def make_subjects
  puts "Creating subjects"
  subjects_names = ["عربي مرحلة أولى","إنجليزي مرحلة أولى", "حساب مرحلة ثانية","حديث مرحلة أولي" ]
  lessons_names = ["حرف الضاد", "رقم واحد", "رقم إثنين", "حرف  الألف", "حديث ١" ]
  subjects = []
  number =10
  number.times do |n|
    subject = Subject.create!( :description => subjects_names.sample,
                               :level => Faker::Lorem.words.join(" ")
                             )
    10.times do |t|
      lesson = Lesson.new(:description => lessons_names.sample)
      performance_metrics = Hash.new 
      3.times do |m|
        performance_metrics[Faker::Lorem.words.join(" ")] = [10,15,20,50].sample 
      end
      lesson.performance_metrics = performance_metrics
      subject.lessons += [lesson]
    end
    subjects << subject
  end
  subjects

end

def make_class_subjects (teachers, subjects)
  puts "Creating class subjects"
  class_subjects = []
  number = 100
  number.times do |n|
    subject = subjects.sample
    class_subject = ClassSubject.create!(:description => subject.description)  
    class_subject.subject = subject
    class_subject.lessons = subject.lessons
    class_subject.subject_teachers = [teachers.sample]
    class_subject.save!
    class_subjects << class_subject
  end
  class_subjects
end

def make_classes(teachers, students, class_subjects)
  puts "Creating classes"
  class_names = ["فصل (ا)","فصل(ب)","فصل(ج)" ,"فصل(بطوط)"]
  classes = []
  number = 10
  number.times do |n|
    teacher = teachers.sample
    teachers = teachers - [teacher]
    nclass = NClass.create!(:name => class_names.sample, :class_teacher => teacher)
    puts "#{nclass.name} - #{nclass.class_teacher.first_name}"
    (1..3).each do |c|
      student = students.sample
      students = students - [student]
      nclass.students << students.sample
    end
    (1..3).each do |c|
      class_subject = class_subjects.sample
      class_subjects = class_subjects -[class_subject]
      nclass.subjects << class_subject
    end
    nclass.save!
    classes<<nclass
  end
  classes
end

def make_class_evaluation_records(students, class_subjects)
  records =[]
  puts "Creating Class evaluation records"
  class_subjects.each do |class_subject|
    class_evaluation_record = ClassEvaluationRecord.new
    class_evaluation_record.supervising_teacher = class_subject.subject_teachers.first
    class_evaluation_record.date_of_entry = Date.today
    class_evaluation_record.lesson = class_subject.lessons.sample
    class_evaluation_record.class_subject = class_subject
    class_evaluation_record.save!
    number = 10
    number.times do |n|
      student = students.sample
      evaluation_record = EvaluationRecord.new
      evaluation_record.student = student
      evaluation_record.date_of_entry = Date.today
      evaluation_record.grade = [true, false].sample
      evaluation_record.supervising_teacher = class_subject.subject_teachers.first
      evaluation_record.save!
      class_evaluation_record.evaluation_records += [evaluation_record]
    end
    records << class_evaluation_record
  end
  records
end

def make_class_attendance_records(students, class_subjects)
  records =[]
  puts "Creating Class attendance records"
  class_subjects.each do |class_subject|
    class_attendance_record = ClassAttendanceRecord.new
    class_attendance_record.supervising_teacher = class_subject.subject_teachers.first
    class_attendance_record.date_of_entry = Date.today
    class_attendance_record.lesson = class_subject.lessons.sample
    class_attendance_record.class_subject = class_subject
    class_attendance_record.save!
    number = 10
    number.times do |n|
      student = students.sample
      attendance_record = AttendanceRecord.new
      attendance_record.student = student
      attendance_record.date_of_entry = Date.today
      attendance_record.present = [true, false].sample
      attendance_record.supervising_teacher = class_subject.subject_teachers.first
      attendance_record.save!
      class_attendance_record.attendance_records += [attendance_record]
    end
    records << class_attendance_record
  end
  records
end

def make_class_subject_schedule(class_subjects)
  puts "Creating class subject schedule"
  class_subjects.each do |class_subject|
    class_subject.lessons.each do |lesson|
      entry = ClassScheduleEntry.new
      entry.week = (1..4).to_a.sample #TODO make sure there are no conflicts between lessons
      entry.month = (1..12).to_a.sample
      entry.lesson = lesson
      entry.class_subject = class_subject
      entry.save!
    end
  end

end







