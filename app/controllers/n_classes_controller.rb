class NClassesController < ApplicationController
  before_filter :authenticate_user!

  def index
  	@page_index = params[:page_index]
  	@page_index ||= 1
  	@classes = NClass.page(@page_index)
    
    respond_to do |format|
      format.html
    end
  end

  def show
    if params[:date].present?
      @start_date = Date.parse(params[:date])
    else
      @start_date = Date.today.beginning_of_week(:saturday)
  	end
    @end_date = @start_date + 6
    @n_class_id = params[:id]
  	if @n_class_id.present?
  	  @n_class = NClass.where(_id: @n_class_id).first
    else
      @n_class = NClass.all.first
    end
    @teacher = @n_class.teacher_name
    @students = @n_class.students
    @subjects = @n_class.subjects

    respond_to do |format|
      format.html
    end
  end

  def enrolled_students
    @n_class = NClass.find params[:n_class_id]
    @students = @n_class.students
  end

end