# encoding: utf-8
require 'csv'
class Importer::Importer

   def self.sheet_to_hash filepath
    i = 0 
    rows = [] 
    keys = [] 
    lines = CSV.read(filepath, :quote_char => "`")
    lines.each do |row|       
      if i == 0
        row.each_with_index do |col, index|     
          keys << col end    
      else
        row_hash = Hash.new
        row.each_with_index do |col, index|
          next if col.nil?
          col.delete!('`')
          row_hash[keys[index]] = col   
          row_hash[keys[index].to_sym] = col
        end
        rows << row_hash  
      end   
      i+= 1
    end 
    sheet = { keys: keys, rows:rows}
  end

  def self.import_subject_lessons filepath, subject
    subject = Subject.where(description: subject).first
    lessons = []
    sheet = sheet_to_hash filepath
    sheet[:rows].each do |row|
      lesson = Lesson.new
      lesson.description = row[:name]
      lessons << lesson
      lesson.subject = subject
      subject.save! 
    end
  end

  def self.save_all_students filepath, class_name
    sheet = sheet_to_hash filepath

    # The class
    begin
      nclass = NClass.find_by name: class_name
    rescue
      n_class = nil
    end
    if nclass.blank?
      return
    end

    sheet[:rows].each do |row|
      
      # Add the student
      student = Student.create!( 
                first_name: row[:first_name],
                last_name: row[:last_name],
                address: row[:address],
                date_of_birth: row[:date_of_birth],
                gender: row[:gender],
                national_id: (row[:national_id]).to_s
                )
      
       student.avatar.store!(File.open(Rails.root.join("lib/importer/photos/#{row[:photo]}"))) unless row[:photo].blank?

      # Create the father as well only if the name is not blank (since it's forced by the model)
      unless row[:father_fname].blank?
        father = Person.create!( first_name: row[:father_fname],
                              last_name: row[:father_lname],
                              address: row[:address],
                              gender: :male,
                              educational_background: row[:father_edu],
                              job: row[:father_job],
                            )
        relation = student.relatives.build related: father, relation_type: :father
        relation.save!
      end
      
      # Create the mother only if the name is not blank (since it's forced by the model)
      unless row[:mother_fname].blank?
        mother = Person.create!( first_name: row[:mother_fname],
                              last_name: row[:mother_lname],
                              address: row[:address],
                              gender: :female,
                              educational_background: row[:mother_edu],
                              job: row[:mother_job],
                            )  
        relation = student.relatives.build related: mother, relation_type: :mother
        relation.save!
      end
   


      # Set the class
      student.n_class = nclass
      
      # Save!
      student.save!
    end
  end

  def self.save_all_students filepath, class_name
    sheet = sheet_to_hash filepath

    # The class
    begin
      nclass = NClass.find_by name: class_name
    rescue
      n_class = nil
    end
    if nclass.blank?
      return
    end

    sheet[:rows].each do |row|
      
      # Add the student
      student = Student.create!( 
                first_name: row[:first_name],
                last_name: row[:last_name],
                address: row[:address],
                date_of_birth: row[:date_of_birth],
                gender: row[:gender],
                national_id: (row[:national_id]).to_s
                )
      
       student.avatar.store!(File.open(Rails.root.join("lib/importer/photos/#{row[:photo]}"))) unless row[:photo].blank?

      # Create the father as well only if the name is not blank (since it's forced by the model)
      unless row[:father_fname].blank?
        father = Person.create!( first_name: row[:father_fname],
                              last_name: row[:father_lname],
                              address: row[:address],
                              gender: :male,
                              educational_background: row[:father_edu],
                              job: row[:father_job],
                            )
        relation = student.relatives.build related: father, relation_type: :father
        relation.save!
      end
      
      # Create the mother only if the name is not blank (since it's forced by the model)
      unless row[:mother_fname].blank?
        mother = Person.create!( first_name: row[:mother_fname],
                              last_name: row[:mother_lname],
                              address: row[:address],
                              gender: :female,
                              educational_background: row[:mother_edu],
                              job: row[:mother_job],
                            )  
        relation = student.relatives.build related: mother, relation_type: :mother
        relation.save!
      end
   


      # Set the class
      student.n_class = nclass
      
      # Save!
      student.save!
    end
  end

  def self.import_students
    filenames = ['المجموعة الخامسة.csv', 'المجموعة السادسة.csv', 'فصل أ\ رانيا سيد.csv', 
                 'فصل أ\ رباب.csv', 'فصل أ\ شادية جمال.csv', 'فصل أ\ شادية سعيد.csv',
                 'فصل أ\ ماجدة.csv', 'فصل أ\ ناهد.csv']
    filenames.each do |filename|
      save_all_students Rails.root.join("lib/importer/files/batch2/#{filename}"), filename.gsub('.csv','')
    end
  end

  def self.import_lessons
    import_subject_lessons Rails.root.join('lib/importer/files/arabic.csv'), 'لغة عربية'
    import_subject_lessons Rails.root.join('lib/importer/files/math.csv'), 'حساب'
    import_subject_lessons Rails.root.join('lib/importer/files/english.csv'), 'لغة انجليزية'
    import_subject_lessons Rails.root.join('lib/importer/files/heseya.csv'), 'الحياة الحسية'
    import_subject_lessons Rails.root.join('lib/importer/files/amaleya.csv'), 'الحياة العملية'
    import_subject_lessons Rails.root.join('lib/importer/files/thakafa.csv'), 'الركن الثقافي'
    import_subject_lessons Rails.root.join('lib/importer/files/islamic.csv'), 'تربية اسلامية'
  end

  def self.import_pics path
    filenames = Dir.entries(Rails.root.join(path)).select {|f| !File.directory? f}
    filenames.each do |filename|
      prefix = filename.split('.')[0]
      next if prefix.ends_with? 'X'
      student_id = prefix.split('_')[0]
      begin
        student = Student.find student_id
      rescue Exception
        student = Student.where(first_name: /#{student_id}/, last_name: /#{prefix.split('_')[1]}/).first
        unless student.present?
          puts "unable to find student: #{student_id}"
          next
        end
      end
      #puts open(Rails.root.join("#{path}/#{filename}"))
      student.remote_avatar_url = open(Rails.root.join("#{path}/#{filename}"))
      student.save!
    end
  end

end