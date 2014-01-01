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

  def self.import_students
    save_all_students Rails.root.join('lib/importer/files/abeer_montessori_5.csv'), 'المجموعة الخامسة'
    save_all_students Rails.root.join('lib/importer/files/abeer_montessori_6.csv'), 'المجموعة السادسة'
    save_all_students Rails.root.join('lib/importer/files/elham_class_2.csv'), 'فصل 2'
    save_all_students Rails.root.join('lib/importer/files/magda_montessori_3.csv'), 'المجموعة الثالثة'
    save_all_students Rails.root.join('lib/importer/files/magda_montessori_4.csv'), 'المجموعة الرابعة'
    save_all_students Rails.root.join('lib/importer/files/nahed_class3.csv'), 'nفصل 3'
    save_all_students Rails.root.join('lib/importer/files/rabab_class1.csv'), 'فصل 1'
    save_all_students Rails.root.join('lib/importer/files/shadya_montessori_1.csv'), 'المجموعة الأولى'
    save_all_students Rails.root.join('lib/importer/files/shadya_montessori_2.csv'), 'المجموعة الثانية'
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