class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    # Commenting out the following lines as per 8.5.1 
    # user = User.find_by(email: params[:session][:email].downcase)
    
    # Adding the following as per 8.5.1
    user = User.find_by_email(params[:email].downcase)
    if user && user.authenticate(params[:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to users_path
  end
end
