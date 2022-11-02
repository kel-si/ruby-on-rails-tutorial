class UsersController < ApplicationController
  # arrange for a particular method to be called before actions
  # by default, before filters apply to all controller actions
  # here we have limited filter to act on only edit and update
  before_action :logged_in_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
  end

  # for a GET request
  def new
    @user = User.new
  end

  # for a POST request
  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      flash[:success] = "Welcome to the Sample App!🦋"
      # @user here is equivalent to user_url(@user)
      redirect_to @user
    else
      # corresponds to HTTP status 422 Unprocessable Entry
      render 'new', status: :unprocessable_entity
    end
  end

  # still a GET request (update would be PATCH)
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile Updated🌱"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

      def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end

      def logged_in_user
        unless logged_in?
          flash[:danger] = "Please log in 🐝"
          redirect_to login_path, status: :see_other
        end
      end
end
