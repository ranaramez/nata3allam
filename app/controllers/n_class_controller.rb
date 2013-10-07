class NClassController < ApplicationController
  before_filter :authenticate_user!

  def index
  	@page_index = params[:page_index]
  	@page_index ||= 1
  	@classes = NClass.page(@page_index).per(5)
  end

  def show
  	@n_class_id = params[:n_class_id]
  	if @n_class_id.present?
  	  @n_class = NClass.where(_id: @n_class_id).first
    else
      @n_class = NClass.all.first
    end
    @teacher = @n_class.teacher_name
    @students = @n_class.students
    @subjects = @n_class.subjects
  end
end