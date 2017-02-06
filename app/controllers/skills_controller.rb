class SkillsController < ApplicationController
  skip_before_filter :authenticate_admin!
  before_filter :authenticate_for_skills!
  before_action :set_skill, only: [:show, :edit, :update, :destroy]
  before_action :set_grouped_skills, only: [:index]
  expose(:users_with_skill) do
    UsersForSkillQuery.new(skill: @skill, user: current_user).results
  end
  expose(:skill_categories) { SkillCategory.all }

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @grouped_skills_by_category }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
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
      if @skill.valid?

        format.html { redirect_to @skill, notice: 'Draft Skill was successfully created.' }
        format.json { render json: @skill, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if ::Skills::Update.new(@skill, skill_params, current_user).call
        format.html { redirect_to @skill, notice: 'Request for changing skill was successfully created. Ask someone to review and accept it.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /skills/1
  # DELETE /skills/1.json
  def destroy
    @skill.destroy
    respond_to do |format|
      format.html { redirect_to skills_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_skill
    @skill = Skill.find(params[:id])
  end

  def set_grouped_skills
    @skills = Skill.eager_load(:skill_category).all.order(:name)
    @grouped_skills_by_category = @skills.group_by do |skill|
      skill.skill_category.name
    end.sort_by{ |key, _| key }.to_h
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def skill_params
    params.require(:skill).permit(
      :name, :description, :rate_type, :skill_category_id,
      :requester_explanation
    )
  end
end
