class FeatureRequestMailer < ApplicationMailer
  default to: "feedback@wizzle.gifts"

  def feature_request
    @idea = params[:idea]
    @user_email = params[:email].presence || "No email provided"
    mail(subject: "New Feature Request for Wizzle", from: @user_email)
  end
end