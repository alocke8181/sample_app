class SessionsController < ApplicationController
  def new
  end

  def create
    session = params[:session]
    user = User.find_by(email: session[:email].downcase)
    if user&.authenticate(session[:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      remember user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email or password'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
