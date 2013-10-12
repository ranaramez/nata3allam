module ScheduleGenerator

  def self.generate_schedule
    classes = NClass.all
    classes.each do |n_class|
      n_class.subjects.each do |subject|
        month = Date.today.month
        entries = ClassScheduleEntry.where(month: month, "class_subject._id" => subject._id)
        entries.each {|entry| entry.destroy}
        subject.lessons.page(1).per(4).each_with_index do |lesson, index|
          entry = ClassScheduleEntry.new
          entry.week = index
          entry.month = month
          entry.lesson = lesson
          entry.class_subject = subject
          entry.save!
        end
      end
    end
  end

end