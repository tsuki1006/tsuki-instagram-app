class UnfollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    account = User.find(params[:account_id])
    current_user.unfollow!(account)
    render json: { status: 'ok' }
  end
end