class Students::AvatarsController < ApplicationController

  def new
    @avatar = Avatar.new
    @student_id = params[:student_id]
    @student = Student.where(_id: @student_id).first
  end

  def create
  	@person = Person.where(_id:params[:avatar][:person_id]).first
  	@person.avatar = nil
  	@person.save!
    avatar = Avatar.new(params[:avatar])
    puts params
    avatar.save!
    redirect_to admin_student_path(avatar.person)
  end

end