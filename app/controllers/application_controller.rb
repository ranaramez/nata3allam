class ApplicationController < ActionController::Base

  before_filter :set_locale
  protect_from_forgery

  protected

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    @stylesheet_direction = I18n.locale == :ar ? 'rtl' : 'ltr'
  end
end
