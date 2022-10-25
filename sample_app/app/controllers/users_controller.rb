class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    debugger
    @user = User.new(user_params)
    if @user.save
    else
      # corresponds to HTTP status 422 Unprocessable Entry
      render 'new', status: :unprocessable_entry
    end
  end

  private

    def user_params
    params.require(:user).permit(:name, :email, :password,
                                                  :password_confirmation)
    end
end
