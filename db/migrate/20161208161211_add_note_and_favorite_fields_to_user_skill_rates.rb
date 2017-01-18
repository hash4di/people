class AddNoteAndFavoriteFieldsToUserSkillRates < ActiveRecord::Migration
  def change
    add_column :user_skill_rates, :note, :string
    add_column :user_skill_rates, :favorite, :boolean, default: false
  end
end
