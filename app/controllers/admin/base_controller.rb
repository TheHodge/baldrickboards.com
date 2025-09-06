class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!

  private

  def authenticate_admin!
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
