class HomeController < ApplicationController
  layout 'home_layout'

  def index
    redirect_to admin_dashboard_index_path if user_signed_in?
  end

end