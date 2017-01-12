class UserSkillRatesController < ApplicationController
  expose(:user_skill_rate) { UserSkillRate.find(params[:id]) }
  expose(:grouped_skills_by_category) do
    UserSkillRatesQuery.new(current_user).results_by_categories
  end

  def index
    respond_to do |format|
      format.html
      format.json { render json: grouped_skills_by_category }
    end
  end

  def update
    respond_to do |format|
      if is_user_skill? && update_user_skill_rate
        format.html { redirect_to user_skill_rate, notice: 'Skill was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: user_skill_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def update_user_skill_rate
    ::Skills::UserSkillRates::Update.new(
      user_skill_rate_id: params[:id],
      params: user_skill_rate_params
    ).call
  end

  def is_user_skill?
    user_skill_rate.user == current_user
  end

  def user_skill_rate_params
    params.require(:user_skill_rate).permit(:rate, :note, :favorite)
  end
end
