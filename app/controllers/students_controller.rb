class StudentsController < ApplicationController
  before_filter :authenticate_user!, only: [:evaluation, :update, :edit, :new]

  #layout "application", except: [:index, :show]
	
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
    
    unless current_user.present?
      @page_title = "our_children"
      @sub_page = @page_title
      render  'guest_index', layout: "application_guest" and return 
    else
      render
    end
    
	end

  def show
    @student = Student.find params[:id]
    unless current_user.present?
      render  'guest_show', layout: "application_guest" and return 
    else
      render
    end
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
    student_hash = params[:student]
    
    if student_hash["date_of_birth(3i)"]
      student_hash[:date_of_birth] = "#{student_hash['date_of_birth(3i)']}/#{student_hash['date_of_birth(2i)']}/#{student_hash['date_of_birth(1i)']}"
    end
    @student.update_attributes(student_hash)
    respond_to do |format|
      format.html {redirect_to student_path(@student)} unless params[:student][:avatar].present?
      format.js if params[:student][:avatar].present?
    end

  end

  def create
    @student = Student.new
    student_hash = params[:student]
    
    if student_hash["date_of_birth(3i)"]
      student_hash[:date_of_birth] = "#{student_hash['date_of_birth(3i)']}/#{student_hash['date_of_birth(2i)']}/#{student_hash['date_of_birth(1i)']}"
    end
    @student.update_attributes(student_hash)
    redirect_to student_path(@student)
  end

  def new
    @student = Student.new
    related = Person.new(:gender => :female)
    @student.relatives << Relative.new(person: @student, related: related, relation_type: :mother)
    related = Person.new(:gender => :male)
    @student.relatives << Relative.new(person: @student, related: related, relation_type: :father)
  end

  def edit
    @student = Student.find params[:id]
    unless @student.mother.present?
      related = Person.new(:gender => :female)
      @student.relatives << Relative.new(person: @student, related: related, relation_type: :mother)
    end
    unless @student.father.present?
      related = Person.new(:gender => :male)
      @student.relatives << Relative.new(person: @student, related: related, relation_type: :father)
    end
  end


end