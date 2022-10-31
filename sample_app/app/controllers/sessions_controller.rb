class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # &. is "safe navigation" operator
    if user&.authenticate(params[:session][:password])
      # clear session to prevent session fixation prior to log in
      reset_session
      log_in user
      redirect_to user
    else
      # create error message
      flash.now[:danger] = "Invalid email/password combination🤚"
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end
end
