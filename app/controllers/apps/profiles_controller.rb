class Apps::ProfilesController < Apps::ApplicationController
  def show
    @profile = current_user.prepare_profile
  end

  def update
    @profile = current_user.prepare_profile
    @profile.assign_attributes(profile_params)
    @profile.save!
    render json: @profile
  end

  private
  def profile_params
    params.require(:profile).permit(
      :avatar
    )
  end
end
