class Admin::SessionsController < ApplicationController
  before_action { @baldrickboard_page = true; @hide_newsletter_footer = true }

  def new
    # Show login form
  end

  def create
    password = params[:password]
    correct_password = Rails.application.credentials[:admin_password]

    if password == correct_password
      session[:admin_authenticated] = true
      redirect_to admin_root_path, notice: 'Successfully logged in to admin area.'
    else
      flash.now[:alert] = 'Invalid password. Please try again.'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:admin_authenticated] = nil
    redirect_to root_path, notice: 'Successfully logged out of admin area.'
  end
end
