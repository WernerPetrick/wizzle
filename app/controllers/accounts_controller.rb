class AccountsController < ApplicationController
  before_action :require_login

  def destroy
    current_user.anonymize!
    sign_out
    redirect_to root_path, notice: "Your account has been deleted."
  end
end