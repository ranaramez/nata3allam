class SearchController < ApplicationController
  before_filter :authenticate_user!

  def autocomplete
    query_term = params[:term]
    students = Student.where(full_name_generated:/#{query_term}/)
    @students = []
    @students = students.map { |s| {value: s.full_name_generated,  id: s.slugs.first } }
    render :json => @students
  end

end