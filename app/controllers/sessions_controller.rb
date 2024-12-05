class SessionsController < ApplicationController
  def new
  end

  def create
    session = params[:session]
    user = User.find_by(email: session[:email].downcase)
    if user && user.authenticate(session[:password])
      #login
    else
      flash[:danger] = 'Invalid email or password'
      render 'new'
    end
  end

  def destroy
  end
end
