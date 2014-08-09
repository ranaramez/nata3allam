class Students::EvaluationRecordsController < ApplicationController

  def index
    @student = Student.find params[:student_id]
    @subject = ClassSubject.find params[:subject_id]
    @records = @student.get_detailed_subject_report @subject
  end

end