class SecretSantasController < ApplicationController
  before_action :require_login
  before_action :set_community
  before_action :set_secret_santa, only: [:show, :edit, :update, :destroy, :generate_assignments]
  before_action :check_admin_access, except: [:show]

  def show
    redirect_to @community unless member_access?
    @my_assignment = current_assignment
  end

  def new
    @secret_santa = @community.secret_santas.build
  end

  def create
    @secret_santa = build_secret_santa
    save_or_render_form
  end

  def edit
    redirect_to [@community, @secret_santa] unless @secret_santa.can_edit?
  end

  def update
    update_or_render_form
  end

  def destroy
    @secret_santa.destroy
    redirect_with_notice("Secret Santa deleted.")
  end

  def generate_assignments
    generate_and_redirect
  end

  private

  def set_community
    @community = Community.find(params[:community_id])
  end

  def set_secret_santa
    @secret_santa = @community.secret_santas.find(params[:id])
  end

  def check_admin_access
    redirect_to @community unless @community.can_manage_members?(current_user)
  end

  def member_access?
    @community.member?(current_user)
  end

  def build_secret_santa
    @community.secret_santas.build(secret_santa_params.merge(created_by: current_user))
  end

  def save_or_render_form
    if @secret_santa.save
      redirect_with_notice("Secret Santa created! Generate assignments when ready.")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update_or_render_form
    if @secret_santa.update(secret_santa_params)
      redirect_with_notice("Secret Santa updated!")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def generate_and_redirect
    if generate_assignments_service.call
      redirect_with_notice("Assignments generated! Members can now see their matches.")
    else
      redirect_with_alert("Unable to generate assignments. Need at least 3 members.")
    end
  end

  def generate_assignments_service
    SecretSantaAssignmentService.new(@secret_santa)
  end

  def current_assignment
    @secret_santa.secret_santa_assignments.find_by(giver: current_user)
  end

  def redirect_with_notice(message)
    flash[:notice] = message
    redirect_to community_secret_santa_path(@community, @secret_santa)
  end

  def redirect_with_alert(message)
    flash[:alert] = message
    redirect_to community_secret_santa_path(@community, @secret_santa)
  end

  def secret_santa_params
    params.require(:secret_santa).permit(:title, :description, :event_date, :reveal_date, :budget_limit)
  end
end