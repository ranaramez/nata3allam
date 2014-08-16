class StudentsController < ApplicationController

  layout "application_guest"
	
  def index

    @page = params[:page]
    @page ||= 1
    @page = @page.to_i

    if params[:term].present?
      @students=Student.where(full_name_generated:/#{params[:term]}/)
    else 
      @students = Student.all
    end
    @pages_count = (@students.count / 20.0).ceil

    @students = Kaminari.paginate_array(@students).page(@page).per(20)
    
    @page_title = "our_children"
    @sub_page = @page_title
    
	end

  def show
    @student = Student.find params[:id]
  end



end