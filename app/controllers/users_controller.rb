class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update]#, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  #before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:sucess] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  def show
    @user = User.find(params[:id])
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_salt, :password_confirmation) #:salt, :encrypted_password)
  end

  def signed_in_user
    unless signed_in?   
      store_location
      redirect_to new_session_path, notice: "Please sign in."
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless correct_user?(@user)
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

end
