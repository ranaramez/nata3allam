class Students::StudentBehaviorRecordsController < ApplicationController

  def new
    @student = Student.where(_id: params[:student_id]).first
    if params[:date].present?
      @start_date = Date.parse(params[:date])
    else
      @start_date = Date.today.beginning_of_week(:saturday)
    end
    @end_date = @start_date + 6

    @behavior_record = @student.template_behavior_record @start_date

  end

  def create
    id = params[:student_behavior_record][:_id]
    if id.present?
      record = StudentBehaviorRecord.where(_id: id).first
    end
    record ||= StudentBehaviorRecord.new
    student_id = params[:student_behavior_record][:student_id]
    @student = Student.where(_id: student_id).first
    @date = record.from_date
    record.update_attributes params[:student_behavior_record]
    record.save!

    redirect_to new_student_student_behavior_record_path( id: id, student_id: student_id, date: @date)

  end 

end