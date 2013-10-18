class ClassEvaluationRecordsController < ApplicationController

  def edit
    if params[:month].present?
      @month = params[:month].to_i
    else
      @month = Date.today.month
    end
    @month = 1 if @month < 1
    @month = (@month % 12) if @month > 12

    @class_subject ||= ClassSubject.where(_id: params[:class_subject_id]).first
    @students = @class_subject.n_class.students
    @n_class = @class_subject.n_class
    @teacher = @n_class.teacher_name    
    @evaluation_record = @class_subject.class_evaluation_records.all.first
    @evaluation_record ||= ClassEvaluationRecord.template @class_subject, @students
    @lessons = @class_subject.class_schedule_entries.where(month: @month).map(&:lesson)

  end

  def create
    id = params[:class_evaluation_record][:_id]
    if id.present?
      record = ClassEvaluationRecord.where(_id: id).first
    end
    record ||= ClassEvaluationRecord.new
    record.update_attributes params[:class_evaluation_record]
    @class_subject = record.class_subject
    lessons = @class_subject.class_schedule_entries.where(month: params[:month].to_i).map(&:lesson)

    record.evaluation_records.each_with_index do |evaluation_record, i|
      edited_grades = evaluation_record.grades.where("lesson_id" => {"$ne" => nil})
      puts edited_grades.map(&:as_document)
      grades =  []
      edited_grades.each_with_index do |grade, j|
        lesson_id = params[:class_evaluation_record][:evaluation_records_attributes][i.to_s][:grades_attributes][j.to_s]["lesson_id"]
        grade.lesson = @class_subject.lessons.where(_id: lesson_id).first
        grade.set "lesson_id", nil
        grades << grade
      end
      evaluation_record.grades += grades
      evaluation_record.grades = evaluation_record.grades.uniq
      evaluation_record.save!
    end
    redirect_to edit_class_evaluation_record_path( id: id, class_subject_id: @class_subject._id)
  end

end