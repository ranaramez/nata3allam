class ClassScheduleEntriesController < ApplicationController

  def index
    if params[:month].present?
      @month = params[:month].to_i
    else
      @month = Date.today.month
    end
    @month = 1 if @month < 1
    @month = (@month % 12) if @month > 12
    @n_class_id = params[:n_clas_id]
    if @n_class_id.present?
      @n_class = NClass.where(_id: @n_class_id).first
    else
      @n_class = NClass.all.first
    end
    @schedule = @n_class.class_monthly_schedule @month
    @students =@n_class.students
  end

  def new

  end

  def destroy

    class_schedule_entry = ClassScheduleEntry.where(_id: params[:id]).first
    month = class_schedule_entry.month
    n_class = class_schedule_entry.class_subject.n_class
    
    class_schedule_entry.destroy

    redirect_to class_schedule_entries_path(n_clas_id: n_class._id, month: month)
  end

  def create

   @month = params[:month].to_i
   @week = params[:week].to_i
   @class_subject_id = params[:class_subject_id]
   class_subject = ClassSubject.where(_id: params["class_subject_id"]).first
   lesson = class_subject.lessons.where(_id: params["class_schedule_entry"]["lesson"]).first
   entry = ClassScheduleEntry.new
   entry.month = @month
   entry.week = @week
   entry.lesson = lesson
   entry.class_subject = class_subject
   entry.save!
   @n_class = class_subject.n_class

   redirect_to class_schedule_entries_path(n_clas_id: @n_class._id, month: @month)
  end

end