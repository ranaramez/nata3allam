class AdminDashboardController < ApplicationController

  before_filter :authenticate_user!
  
  def index
    @students_count = Student.count 
    @classes_count = NClass.count 
    @teachers_count = 0
    Teacher.all.map{|t| @teachers_count = @teachers_count+1 if(t.n_class.present? || t.class_subject != [])}
  end
end