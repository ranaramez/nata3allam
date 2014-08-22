class Admin::RequestsController < ApplicationController

  before_filter :authenticate_user!
  
  def index
    if params[:date].present?
      @start_date = Date.parse(params[:date])
    else
      @start_date = Date.today.beginning_of_week(:saturday)
    end
    @end_date = @start_date + 7
    @requests = Request.get_requests @start_date.to_datetime, @end_date.to_datetime
  end

  def show
    @request = Request.find params[:id]
  end

  def update
    @request = Request.find params[:id]
    @request.update_attributes(params[:request])
    @request.reload
  end

end