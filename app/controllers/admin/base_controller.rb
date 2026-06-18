class Admin::BaseController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action { @hide_newsletter_footer = true }

  private

  def authenticate_admin!
    # Skip authentication in development
    return if Rails.env.development?
    
    unless admin_authenticated?
      session[:admin_return_to] = request.fullpath
      redirect_to admin_login_path, alert: 'Please log in to access the admin area.'
    end
  end

  def admin_authenticated?
    session[:admin_authenticated] == true
  end

  def admin_login_path
    '/admin/login'
  end
end
