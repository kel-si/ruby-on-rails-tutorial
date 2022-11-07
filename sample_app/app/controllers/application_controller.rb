class ApplicationController < ActionController::Base
    include SessionsHelper

    private
        # confirms logged in user
        def logged_in_user
        unless logged_in?
            # store requested url in session variable
            store_location
            flash[:danger] = "Please log in 🐝"
            redirect_to login_path, status: :see_other
        end
        end    
end