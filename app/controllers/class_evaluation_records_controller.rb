class ClassEvaluationRecordsController < ApplicationController

  def edit
    lesson_id = params[:lesson_id]
    @class_subject ||= ClassSubject.where(_id: params[:class_subject_id]).first
    @lesson = @class_subject.lessons.where(_id: lesson_id).first
    @students = @class_subject.n_class.students
    @n_class = @class_subject.n_class
    @teacher = @n_class.teacher_name    
    @evaluation_record = @class_subject.class_evaluation_records.where('lesson._id' => Moped::BSON::ObjectId(lesson_id)).first
    @evaluation_record ||= ClassEvaluationRecord.template @class_subject, @students, @lesson
  end

  def create
    lesson_id = params[:lesson_id]
    id = params[:class_evaluation_record][:_id]
    if id.present?
      record = ClassEvaluationRecord.where(_id: id).first
    end
    record ||= ClassEvaluationRecord.new
    class_subject_id = params[:class_evaluation_record][:class_subject_id]
    @class_subject = ClassSubject.where(_id: class_subject_id).first
    lesson = @class_subject.lessons.where(_id: lesson_id).first
    puts lesson.description, lesson.attributes
    record.lesson = lesson
    record.update_attributes params[:class_evaluation_record]
    record.save!

    redirect_to edit_class_evaluation_record_path( id: id, class_subject_id: @class_subject._id, lesson_id: lesson_id)
  end

end