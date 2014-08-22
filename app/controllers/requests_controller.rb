class RequestsController < ApplicationController

  layout "application_guest"
  
  def create
    request = Request.new
    request.update_attributes(params[:request])
    flash[:success] = I18n.translate('thank_you_msg')
    student = Student.find(params[:request][:student_id])
    redirect_to student_path(student)
  end

  def new
    @page_title = 'help_title'
    @request = Request.new
    @student = Student.find params[:student_id]
  end


end