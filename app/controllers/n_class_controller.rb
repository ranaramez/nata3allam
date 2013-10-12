class NClassController < ApplicationController
  before_filter :authenticate_user!

  def index
  	@page_index = params[:page_index]
  	@page_index ||= 1
  	@classes = NClass.page(@page_index).per(5)
    
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

  def schedule
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
end