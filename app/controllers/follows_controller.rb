class FollowsController < ApplicationController
  before_action :authenticate_user!

  def show
    account = User.find(params[:account_id])
    following_status = current_user.is_following?(account)
    render json: { isFollowing: following_status }
  end
end