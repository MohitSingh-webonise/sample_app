class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.authenticate(params[:session][:email],params[:session][:password])
    if user
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid credentials.'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
