class RelationshipsController < ApplicationController
    before_action :logged_in_user

    def create
        # getting the id of the user to follow
        user = User.find(params[:followed_id])
        # from cookies
        current_user.follow(user)
        redirect_to user
    end

    def destroy
        # finding user who was followed by current user by looking for relationship id
        user = Relationship.find(params[:id]).followed
        current_user.unfollow(user)
        redirect_to user, status: :see_other
    end
end
