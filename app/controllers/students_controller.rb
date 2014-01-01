class StudentsController < ApplicationController
  before_filter :authenticate_user!

	def index

    @students = Student.all

    respond_to do |format|
      format.html # index.html.erb
    end
	end

  def show
    @student = Student.find params[:id]
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
  end

  def update
    @student = Student.find params[:id]
    @student.update_attributes(params[:student])
  end
end