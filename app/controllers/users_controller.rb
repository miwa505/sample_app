class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :not_signed_in,  only: :new
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    # Changing to the following as per 8.5.1 
    # @user = User.new(user_params)
    
    # 8.5.1
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    # Omitting the next line as per Listing 9.14
    # @user = User.find(params[:id])
  end
  
  def update
    # Omitting the next line as per Listing 9.14
    # @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    # 9.6.9
    user = User.find(params[:id])
    if current_user?(user) && current_user.admin?
      flash[:error] = "You can't delete yourself!"
    else
      user.destroy
      flash[:success] = "User deleted."
    end
    redirect_to users_path
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    # Before filters
    
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end  
    
    def not_signed_in
      redirect_to(root_url) if current_user
    end
    
end
