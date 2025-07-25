class Admin::BlogPostsController < ApplicationController
  before_action :require_admin!

  def index
    @posts = BlogPost.order(created_at: :desc)
  end

  def show
    @post = BlogPost.find(params[:id])
  end

  def new
    @post = BlogPost.new
  end

  def create
    @post = BlogPost.new(blog_post_params)
    @post.user = current_user
    if @post.save
      redirect_to admin_blog_posts_path, notice: "Blog post created!"
    else
      render :new
    end
  end

  def edit
    @post = BlogPost.find(params[:id])
  end

  def update
    @post = BlogPost.find(params[:id])
    if @post.update(blog_post_params)
      redirect_to admin_blog_posts_path, notice: "Blog post updated!"
    else
      render :edit
    end
  end

  def destroy
    @post = BlogPost.find(params[:id])
    @post.destroy
    redirect_to admin_blog_posts_path, notice: "Blog post deleted."
  end

  private

  def blog_post_params
    params.require(:blog_post).permit(:title, :body, :published, :image)
  end

  def require_admin!
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end
end