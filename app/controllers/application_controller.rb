class ApplicationController < ActionController::Base

  layout :set_layout
  before_filter :set_layout
  before_filter :set_css_class
  protect_from_forgery

  protected

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    @stylesheet_direction = I18n.locale == :ar ? 'rtl' : 'ltr'
  end

  def set_layout
    if devise_controller?
      'home_layout'
    else
      'application'
    end
  end

  def set_css_class
    @page_class = devise_controller? ? 'login' : ' '
  end
end
