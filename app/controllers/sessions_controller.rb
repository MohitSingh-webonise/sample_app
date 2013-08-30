class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.authenticate(params[:session][:email],params[:session][:password])
    #user = User.find_by(email: params[:session][:email].downcase)
    if user #&& User.find_by(name: params[:session][:name])
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

  # def password_digest
  #   self.salt = BCrypt::Engine.generate_salt
  #   self.password_digest = password_hash = BCrypt::Engine.hash_secret(password, salt)
  # end

end
