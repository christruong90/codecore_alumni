class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email params[:email]
    if user && user.authenticate(params[:password])
      sign_in(user)
      # if the user is an admin redirect to the user show page
      if user.admin?
        redirect_to users_path, notice: "Welcome back mighty admin!"
      # else they are just a regular use and redirect to the normal homepage
      else
        if user.profile == nil
          redirect_to new_profile_path, notice: "Sign in successful!"
        else
          redirect_to profile_path(current_user_profile), notice: "Sign in successful!"
        end
      end
    else
      flash[:alert] = "Wrong credentials!"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You are logged out!"
  end
end
