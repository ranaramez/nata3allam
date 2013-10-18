class StudentsController < ApplicationController
  before_filter :authenticate_user!

	def index

    @students = Student.all

    respond_to do |format|
      format.html # index.html.erb
    end
	end

  def show

  end

end