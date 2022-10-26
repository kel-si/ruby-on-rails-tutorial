class UsersController < ApplicationController
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
      flash[:success] = "Welcome to the Sample App!🦋"
      # @user here is equivalent to user_url(@user)
      redirect_to @user
    else
      # corresponds to HTTP status 422 Unprocessable Entry
      render 'new', status: :unprocessable_entity
    end
  end

  private

    def user_params
    params.require(:user).permit(:name, :email, :password,
                                                  :password_confirmation)
    end
end
