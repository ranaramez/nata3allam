class Admin::SubjectsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @subject = Subject.find params[:id]
  end

  def update
    @subject = Subject.find params[:id]
    lesson = Lesson.new
    lesson.description = params[:subject][:lessons][:description]
    lesson.subject = @subject
    @subject.save!
    @subject.reload
    @subject.class_subjects.each do |class_subject|
      class_subject.lessons = @subject.lessons
      class_subject.save!
    end
    @lessons = @subject.lessons
    redirect_to admin_subject_path(@subject)
  end


end 