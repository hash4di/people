class SkillsController < ApplicationController
  skip_before_filter :authenticate_admin!
  # TODO check if message_to_js is required. If no then remove these functionality
  skip_before_render :message_to_js
  before_filter :authenticate_for_skills!
  before_action :set_skill, only: [:show, :edit, :update, :destroy]
  before_action :set_grouped_skills, only: [:index]
  expose(:users_with_skill) do
    UsersForSkillQuery.new(skill: @skill, user: current_user).results
  end
  expose(:skill_categories) { SkillCategory.all }
  expose(:draft_skills) { @skill.draft_skills.last(5) }
  # TODO add before_filter or validation on skill to not allow to create new draft_skill when last one is not resolved

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

  def edit; end

  def create
    @skill = Skill.new(skill_params)
    respond_to do |format|
      flash.clear
      if change_requester.request(type: 'create')
        format.html { redirect_to change_requester.draft_skill, notice: 'Request for adding skill was successfully created. Ask someone to review and accept it.' }
        format.json { render json: change_requester.draft_skill, status: :created }
      else
        flash[:error] = @skill.errors[:ref_name].first if @skill.errors[:ref_name]
        format.html { render action: 'new' }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if change_requester.request(type: 'update')
        format.html { redirect_to change_requester.draft_skill, notice: 'Request for changing skill was successfully created. Ask someone to review and accept it.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @skill.destroy
    respond_to do |format|
      format.html { redirect_to skills_url }
      format.json { head :no_content }
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

  def skill_params
    params.require(:skill).permit(
      :name, :description, :rate_type, :skill_category_id,
      :requester_explanation
    )
  end
end
