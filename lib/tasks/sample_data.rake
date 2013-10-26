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

   task :init => :environment do
    init
   end
end

def init

  #Admin 

  admin = User.new
  admin.username = "admin"
  admin.email = "admin@net3allem.com"
  admin.first_name = "admin"
  admin.password = "password"
  admin.save!
  puts "Admin Created \n username: admin@net3allem.com \n password: password "

  #Teachers
  teacher1 = Teacher.new
  teacher1.first_name = "ميس نشوى"
  teacher1.save!

  teacher2 = Teacher.new
  teacher2.first_name = "ميس ايمان"
  teacher2.save!


  teacher3 = Teacher.new
  teacher3.first_name = "ميس نازلي"
  teacher3.save!

  teacher4 = Teacher.new
  teacher4.first_name = "ميس رنا"
  teacher4.save!

  teacher4 = Teacher.new
  teacher4.first_name = "ميس هنا"
  teacher4.save!


  teacher5 = Teacher.new
  teacher5.first_name = "ميس صفاء"
  teacher5.save!

  teacher6 = Teacher.new
  teacher6.first_name = "ميس لميا"
  teacher6.save!

  teacher7 = Teacher.new
  teacher7.first_name = "ميس هدى"
  teacher7.save!


  teacher8 = Teacher.new
  teacher8.first_name = "ميس امل"
  teacher8.save!


  teacher9 = Teacher.new
  teacher9.first_name = "ميس سارة"
  teacher9.save!

  puts "Teachers Created ... "

  #Subjects
  arabic = Subject.new
  arabic.description = "لغة عربية"
  arabic.level = 1


  math = Subject.new
  math.description = "حساب"
  math.level = 1

  islamic = Subject.new
  islamic.description = "تربية اسلامية"
  islamic.level = 1

  english = Subject.new
  english.description = "لغة انجليزية"
  english.level = 1

  amaleya = Subject.new
  amaleya.description = "الحياة العملية"
  amaleya.level = 1

  heseya = Subject.new
  heseya.description = "الحياة الحسية"
  heseya.level = 1

  thakafa = Subject.new
  thakafa.description = "الركن الثقافي"
  thakafa.level = 1

  subjects = [arabic, math, islamic, english, amaleya, heseya, thakafa]
  subjects.map{|s| s.save!}

  puts "Subjects Created ... "

  #NClasses 
  montessori1 = NClass.new 
  montessori1.name = "المجموعة الأولى"
  montessori1.class_teacher = teacher1

  montessori2 = NClass.new 
  montessori2.name = "المجموعة الثانية"
  montessori2.class_teacher = teacher2

  montessori3 = NClass.new 
  montessori3.name = "المجموعة الثالثة"
  montessori3.class_teacher = teacher3

  montessori4 = NClass.new 
  montessori4.name = "المجموعة الرابعة"
  montessori4.class_teacher = teacher4

  montessori5 = NClass.new 
  montessori5.name = "المجموعة الخامسة"
  montessori5.class_teacher = teacher5

  montessori6 = NClass.new 
  montessori6.name = "المجموعة السادسة"
  montessori6.class_teacher = teacher6

  class1= NClass.new 
  class1.name = "فصل 1"
  class1.class_teacher = teacher7

  class2= NClass.new 
  class2.name = "فصل 2"
  class2.class_teacher = teacher8

  class3= NClass.new 
  class3.name = "فصل 3"
  class3.class_teacher = teacher9

  classes = [ 
    montessori1, montessori2, montessori3, montessori4, montessori5, montessori6, 
    class1, class2, class3 ]

  classes.map{|s| s.save!}

  puts "Classes created ... "

  Importer::Importer.import_lessons

  puts "Lessons Importing done ... "

  Importer::Importer.import_students

  puts "Importing Students done ..."

   classes.each do |c|
     subjects.each do |s|
        s.reload
        cs = ClassSubject.new
        cs.description = s.description
        # s.lessons.each do |l|
        #   l.class_subject = cs
        #   cs.save!
        # end
        cs.subject= s
        cs.lessons = s.lessons
        cs.save!
        c.subjects << cs
     end
     make_class_subject_schedule(c.subjects)
   end
   puts "Class Subjects created "
   puts "Fake initial schedule created "
   puts "Initial Data compelte! "

  #Import students 
  #make_class_evaluation_records(students, class_subjects)
  #make_class_attendance_records(students, class_subjects)    
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
 #puts "Creating class subject schedule"
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







