class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # log in user
    else
      # create error message
      flash.now[:danger] = "Invalid email/password combination🤚"
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
  end
end
