class RelationshipsController < ApplicationController
    before_action :logged_in_user

    def create
        # getting the id of the user to follow
        @user = User.find(params[:followed_id])
        # from cookies
        current_user.follow(@user)
        respond_to do |format|
            format.html { redirect_to @user }
            format.turbo_stream
        end
    end

    def destroy
        # finding user who was followed by current user by looking for relationship id
       @user = Relationship.find(params[:id]).followed
        current_user.unfollow(@user)
        respond_to do |format|
            format.html { redirect_to @user, status: :see_other }
            format.turbo_stream
        end
    end
end
