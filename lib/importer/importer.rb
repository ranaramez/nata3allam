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