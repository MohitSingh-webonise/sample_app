class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && User.find_by(name: params[:session][:name])
      redirect_to root_path
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
