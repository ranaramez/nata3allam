class StudentsController < ApplicationController
  before_filter :authenticate_user!, only: [:evaluation, :update]

  #layout "application", except: [:index, :show]
	
  def index

    @students = Student.all
    unless current_user.present?
      @page_title = "Our Children"
      render  'guest_index', layout: "application_guest" and return 
    else
      render
    end
    
	end

  def show
    @student = Student.find params[:id]
    #render layout: "application"
  end

  def evaluation
  	student_id = params[:student_id]
  	@student = Student.find student_id
	  if params[:date].present?
      @start_date = Date.parse(params[:date])
    else
      @start_date = Date.today.beginning_of_week(:saturday)
  	end
  	@end_date = @start_date + 6
  	n_class = @student.n_class
  	@subjects =  n_class.present? ? n_class.subjects : []
  	@student_report, @total_done, @total_lessons = @student.get_student_class_report(@start_date)
    @past_student_report = @student.get_student_past_classes_report  @start_date
  end

  def preview
    @student = Student.find params[:student_id]
    @student_progress = @student.get_student_progress
  end

  def update
    @student = Student.find params[:id]
    @student.update_attributes(params[:student])
  end


end