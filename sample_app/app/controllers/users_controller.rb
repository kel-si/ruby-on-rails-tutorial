class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user]) # not the final version (bad)
    if @user.save
    else
      # corresponds to HTTP status 422 Unprocessable Entry
      render 'new', status: :unprocessable_entry
    end
  end
end
