class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:sucess] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render new_user_path
    end
  end

  def show
    @user = User.find(1) #(params[:id])
  end

  private
  def user_params
    params.require(:user).permit(:name, :email) #, :password, :salt, :encrypted_password)
  end

end
