module SessionsHelper
    # logs given user in
    # user is defined in sessions_controller (create action)
    def log_in(user)
        session[:user_id] = user.id
    end

    # returns current logged-in user (if any)
    def current_user
        if session[:user_id]
            @current_user ||= User.find_by(id: session[:user_id])
        end
    end

    def logged_in?
        # return true if not nil (logged in)
        !current_user.nil?
    end

    def log_out
        reset_session
        @current_user = nil
    end
end
