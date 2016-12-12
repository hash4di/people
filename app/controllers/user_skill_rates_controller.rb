class UserSkillRatesController < ApplicationController
  expose(:user_skill_rate) { UserSkillRate.find(params[:id]) }
  expose(:user_skill_rates) { set_user_skill_rates }
  expose(:grouped_skills_by_category) do
    user_skill_rates.group_by { |skill| skill.category }
  end

  def index
    respond_to do |format|
      format.html
      format.json { render json: grouped_skills_by_category }
    end
  end

  def update
    respond_to do |format|
      if user_skill_rate.update(user_skill_rate_params)
        format.html { redirect_to user_skill_rate, notice: 'Skill was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: user_skill_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user_skill_rates
    user_skill_rates ||= UserSkillRate.joins(
      skill: :skill_category
    ).select(
      "
        user_skill_rates.*,
        skills.name as name,
        skills.description as description,
        skills.rate_type as rate_type,
        skill_categories.name as category
      "
    ).where(user_id: current_user.id)
  end

  def user_skill_rate_params
    params.require(:user_skill_rate).permit(:rate, :note, :favorite)
  end
end
