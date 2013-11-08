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

  def self.save_all_students filepath
    sheet = sheet_to_hash filepath
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

      # Create the father as well
      unless row[:father_fname].blank?
        father = Person.create!( first_name: row[:father_fname],
                              last_name: row[:father_lname],
                              address: row[:address],
                              gender: :male,
                              educational_background: row[:father_edu],
                              job: row[:father_job],
                            )
        student.family_members += [father]
      end
      
      # Create the mother
      unless row[:mother_fname].blank?
        mother = Person.create!( first_name: row[:mother_fname],
                              last_name: row[:mother_lname],
                              address: row[:address],
                              gender: :female,
                              educational_background: row[:mother_edu],
                              job: row[:mother_job],
                            )  
        student.family_members += [mother]
      end
      
      student.save!
    end
  end

  def self.import_students
    save_all_students Rails.root.join('lib/importer/files/students.csv')
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

end