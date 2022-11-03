module SessionsHelper
    # logs given user in
    # user is defined in sessions_controller (create action)
    def log_in(user)
        session[:user_id] = user.id
        # guard against session replay attacks
        session[:session_token] = user.session_token
    end

    # remembers a user in a persistent session
    def remember(user)
        user.remember
        cookies.permanent.encrypted[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

    # returns the user corresponding to the remember token cookie
    def current_user
        # if user_id exists..
        if (user_id = session[:user_id])
            user = User.find_by(id: user_id)
            if user && session[:session_token] == user.session_token
                @current_user = user
            end
        elsif (user_id = cookies.encrypted[:user_id])
            user = User.find_by(id: user_id)
            if user && user.authenticated?(:remember, cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end
    end

    # returns true if given user is the current user
    def current_user?(user)
        user && user == current_user
    end

    def logged_in?
        # return true if not nil (logged in)
        !current_user.nil?
    end

    def forget(user)
        # removes digest from db (method in the User model)
        user.forget
        # deletes cookies stored in browser
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

    def log_out
        forget(current_user)
        reset_session
        @current_user = nil
    end

    def store_location
        # stores requested URL in session variable under forwarding_url key 
        session[:forwarding_url] = request.original_url if request.get?
    end
end
