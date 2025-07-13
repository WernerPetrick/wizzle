class ProfilesController < ApplicationController
  def show
    @user = current_user
  end

  def update
    if current_user.update(profile_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to profile_path, notice: "Settings updated!" }
      end
    else
      render turbo_stream: turbo_stream.replace("profile_settings", partial: "profiles/settings_form", locals: { user: current_user })
    end
  end
end
