class Blog::PostsController < ApplicationController
  layout 'blog'
  # before_action :require_admin!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @posts = BlogPost.where(published: true).order(published_at: :desc)
  end

  def show
    @post = BlogPost.find(params[:id])
    redirect_to blog_root_url(subdomain: 'blog'), alert: "Not published" unless @post.published?
  end

  private

  def require_admin!
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end
end
