class Api::FollowsController < Api::ApplicationController
  def show
    account = User.find(params[:account_id])
    following_status = current_user.is_following?(account)
    render json: { isFollowing: following_status }
  end

  def create
    account = User.find(params[:account_id])
    current_user.follow!(account)
    render json: { status: 'ok' }
  end
end
