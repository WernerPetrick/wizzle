class Admin::ImageUploadsController < ApplicationController
  before_action :require_admin!

  def create
    blob = ActiveStorage::Blob.create_and_upload!(
      io: params[:image].tempfile,
      filename: params[:image].original_filename,
      content_type: params[:image].content_type
    )
    render json: { url: url_for(blob) }
  end

  private

  def require_admin!
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end
end