class UserSkillRatesController < ApplicationController
  expose(:user_skill_rate) { UserSkillRate.find(params[:id]) }
  expose(:grouped_skills_by_category_mock) do
    {
      frontend: 
        [
          {
            id: 8,
            category: 'frontend',
            name: 'CSS',
            description: 'react tool',
            rate: 1,
            rate_type: 'range',
            note: 'it is ok',
            favorite: true,
            user_skill_rate_contents:
              [
                {
                  favorite: true,
                  note: 'ntuhatusone',
                  rate: 2,
                  created_at: '2016-12-20T15:35:59.859+01:00'
                },
                {
                  favorite: true,
                  note: 'tneoahuntsau',
                  rate: 3,
                  created_at: '2016-12-20T15:35:59.859+01:00'
                }
              ]
          },
          {
            id: 18,
            category: 'frontend',
            name: 'HTML',
            description: 'react tool',
            rate: 0,
            rate_type: 'boolean',
            note: 'it is ok',
            favorite: false,
            user_skill_rate_contents:
              [
                {
                  favorite: false,
                  note: 'ntuhatusone',
                  rate: 1,
                  created_at: '2016-12-20T15:35:59.859+01:00'
                }
              ]
          }
        ],
      backend: {}
    }
  end
  expose(:grouped_skills_by_category) do
    GroupUserSkillRatesBySkillCategoriesQuery.new(current_user).results
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
