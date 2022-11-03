class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # &. is "safe navigation" operator
    if user && user&.authenticate(params[:session][:password])
      if user.activated?
      forwarding_url = session[:forwarding_url]
      # clear session inc forwarding_url to prevent session fixation prior to log in
      reset_session
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      log_in user
      redirect_to forwarding_url || user
      else
        message = "Account not activated."
        message += "Check your email for the activation link."
        # create error message
        flash.now[:danger] = message
        render 'new', status: :unprocessable_entity
      end
    else
      flash.now[:danger] = "Invalid password / email combination"
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end
