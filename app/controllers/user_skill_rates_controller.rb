class UserSkillRatesController < ApplicationController
  before_action :set_user_skill_rate, only: [:show, :edit, :update, :destroy]
  before_action :set_grouped_skills, only: [:index]


  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @grouped_skills_by_category }
    end
  end

  def update
    respond_to do |format|
      if @user_skill_rate.update(user_skill_rate_params)
        format.html { redirect_to @user_skill_rate, notice: 'Skill was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_skill_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user_skill_rate
    @user_skill_rate = UserSkillRate.find(params[:id])
  end

  def set_grouped_skills
    @user_skill_rates = UserSkillRate.joins(
      skill: :skill_category
    ).select(
      "
        user_skill_rates.*,
        skills.name as name,
        skills.description as description,
        skill_categories.name as category
      "
    ).where(user_id: current_user.id)
    @grouped_skills_by_category = @user_skill_rates.group_by do |skill|
      skill.category
    end
  end

  def user_skill_rate_params
    params.require(:user_skill_rate).permit(:rate, :note, :favorite)
  end
end
