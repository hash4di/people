class SkillsController < ApplicationController
  before_filter :authenticate_admin!
  before_action :set_skill, only: [:show, :edit, :update, :destroy]
  before_action :set_grouped_skills, only: [:index]
  expose(:users_with_skill) do
    UsersForSkillQuery.new(skill: @skill, user: current_user).results
  end

  # GET /skills
  # GET /skills.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @grouped_skills_by_category }
    end
  end

  # GET /skills/1
  # GET /skills/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @skill }
    end
  end

  # GET /skills/new
  def new
    @skill = Skill.new
  end

  # GET /skills/1/edit
  def edit
  end

  # POST /skills
  # POST /skills.json
  def create
    @skill = Skill.new(skill_params)

    respond_to do |format|
      if @skill.save
        format.html { redirect_to @skill, notice: 'Skill was successfully created.' }
        format.json { render json: @skill, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /skills/1
  # PATCH/PUT /skills/1.json
  def update
    respond_to do |format|
      if @skill.update(skill_params)
        format.html { redirect_to @skill, notice: 'Skill was successfully updated.' }
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

  def authenticate_admin!
    return if current_user.talent? || current_user.leader?
    super
  end

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
    params.require(:skill).permit(:name, :description, :rate_type, :skill_category_id)
  end
end
