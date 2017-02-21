class SkillsController < ApplicationController
  # TODO: check if message_to_js is required. If no then remove these functionality
  skip_before_render :message_to_js
  before_filter :authenticate_for_skills!
  before_action :set_skill, only: [:show, :edit, :update]
  before_action :set_grouped_skills, only: [:index]
  expose(:users_with_skill) do
    UsersForSkillQuery.new(skill: @skill, user: current_user).results
  end
  expose(:skill_categories) { SkillCategory.all }
  expose(:draft_skills) { fetch_last_5_draft_skills }

  def index
    respond_to do |format|
      format.html
      format.json { render json: @grouped_skills_by_category }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @skill }
    end
  end

  def new
    @skill = Skill.new
  end

  def edit
    authorize @skill, :access_request_change?
  end

  def create
    @skill = Skill.new(skill_params)
    respond_to do |format|
      flash.clear
      if change_requester.request(type: 'create')
        format.html { redirect_to change_requester.draft_skill, notice: I18n.t('skills.message.create.success') }
        format.json { render json: change_requester.draft_skill, status: :created }
      else
        flash[:error] = @skill.errors[:ref_name].first if @skill.errors[:ref_name]
        format.html { render action: 'new' }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @skill, :access_request_change?
    respond_to do |format|
      if change_requester.request(type: 'update')
        format.html { redirect_to change_requester.draft_skill, notice: I18n.t('skills.message.update.success') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def change_requester
    @change_requester ||= ::Skills::ChangeRequester.new(
      skill: @skill,
      params: skill_params,
      user: current_user
    )
  end

  def set_skill
    @skill = Skill.find(params[:id])
  end

  def set_grouped_skills
    @skills = Skill.eager_load(:skill_category).all.order(:name)
    @grouped_skills_by_category = @skills.group_by do |skill|
      skill.skill_category.name
    end.sort_by{ |key, _| key }.to_h
  end

  def fetch_last_5_draft_skills
    DraftSkillDecorator.decorate_collection(@skill.draft_skills.last(5).reverse)
  end

  def skill_params
    params.require(:skill).permit(
      :name, :description, :rate_type, :skill_category_id,
      :requester_explanation
    )
  end
end
