class UserSkillRatesController < ApplicationController
  expose(:user_skill_rate) { UserSkillRate.find(params[:id]) }
  expose(:user_skill_rates_page) { UserSkillRatesIndexPage.new(user: current_user) }
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
    authorize user_skill_rate
    respond_to do |format|
      if update_user_skill_rate
        sync_skill_rate_with_salesforce
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

  def sync_skill_rate_with_salesforce
    Salesforce::Synchroniser::UserSkillRates
      .new
      .upsert skill_ids: user_skill_rate.skill_id, user_ids: user_skill_rate.user_id
  end

  def user_skill_rate_params
    params.require(:user_skill_rate).permit(:rate, :note, :favorite)
  end
end
